#!/bin/env python3
import usb.core
import usb.util

# Replace these with your device's Vendor ID and Product ID
VENDOR_ID = 0x1209
PRODUCT_ID = 0x0001

# Replace with your device's bulk-in endpoint
BULK_IN_ENDPOINT = 0x81
INTERFACE_NUMBER = 0  # Replace with your device's interface number
TIMEOUT = 1000  # Timeout in milliseconds

def main():
    # Find the USB device
    dev = usb.core.find(idVendor=VENDOR_ID, idProduct=PRODUCT_ID)
    
    if dev is None:
        print("Device not found")
        return
    
    try:
        # Detach kernel driver if necessary
        if dev.is_kernel_driver_active(INTERFACE_NUMBER):
            dev.detach_kernel_driver(INTERFACE_NUMBER)

        # Set configuration
        dev.set_configuration()

        # Claim the interface
        usb.util.claim_interface(dev, INTERFACE_NUMBER)

        # Read bulk data
        print("Starting bulk-in transfer...")
        while True:
            try:
                data = dev.read(BULK_IN_ENDPOINT, 512, TIMEOUT)
                print(f"Received {len(data)} bytes: {data}")
            except usb.core.USBTimeoutError:
                print("No data received (timeout)")
            except usb.core.USBError as e:
                print(f"USB Error: {e}")
                break

    except Exception as e:
        print(f"Error: {e}")
    finally:
        # Release the interface
        usb.util.release_interface(dev, INTERFACE_NUMBER)
        print("Interface released")

if __name__ == "__main__":
    main()

