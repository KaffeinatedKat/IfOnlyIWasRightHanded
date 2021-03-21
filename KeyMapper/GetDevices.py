from keymapper.getdevices import get_devices

List = []

devices = get_devices()
for device in devices:
	List.append(device + ", ")
	
print(" ".join([str(elem) for elem in List]))
