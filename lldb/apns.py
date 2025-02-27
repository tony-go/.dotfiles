import lldb
import re

def apns_callback(frame, bp_loc, dict):
    """
    Callback function that runs when APNs registration is hit.
    Extracts and prints the APNs device token from $x3.
    """
    process = frame.GetThread().GetProcess()
    target = frame.GetThread().GetProcess().GetTarget()

    # Extract the raw device token from register x3
    device_token_value = frame.FindRegister("x3").GetValue()

    if not device_token_value:
        print("❌ No device token found in register x3")
        return False

    # Run an LLDB command to print the token
    interpreter = lldb.debugger.GetCommandInterpreter()
    output = lldb.SBCommandReturnObject()
    interpreter.HandleCommand("po (NSData *)$x3", output)

    raw_token = output.GetOutput().strip()

    # Extract hexadecimal token
    match = re.search(r"<([\da-fA-F\s]+)>", raw_token)
    if not match:
        print("❌ Could not parse APNs token from output.")
        return False

    # Format the token for APNs
    formatted_token = match.group(1).replace(" ", "")

    print(f"✅ APNs Device Token:\n{formatted_token}")

    return False  # Do not stop execution

def capture_device_token(debugger, command, result, internal_dict):
    """
    Set a breakpoint on `objc_msgSend$application:didRegisterForRemoteNotificationsWithDeviceToken:`
    and automatically print the device token.
    """
    target = debugger.GetSelectedTarget()
    bp = target.BreakpointCreateByName("objc_msgSend$application:didRegisterForRemoteNotificationsWithDeviceToken:")
    
    if not bp.IsValid():
        print("❌ Failed to set breakpoint.")
        return
    
    bp.SetScriptCallbackFunction("apns.apns_callback")
    print("✅ Breakpoint set! The device token will be printed when received.")

def register_for_remote_notification(debugger, command, result, internal_dict):
    """
    Manually register for remote notifications.
    """
    debugger.HandleCommand('expr -l objc -O -- [[UIApplication sharedApplication] registerForRemoteNotifications]')
    print("✅ Requested push notification registration.")

# Register the LLDB commands
def __lldb_init_module(debugger, internal_dict):
    debugger.HandleCommand('command script add -f apns.capture_device_token capture_device_token')
    debugger.HandleCommand('command script add -f apns.register_for_remote_notification register_for_remote_notification')
    print("✅ APNs LLDB commands loaded:")
    print("   - `capture_device_token` → Set breakpoint & auto-print token")
    print("   - `register_for_remote_notification` → Request APNs registration")
