import serial

ser = serial.Serial('/dev/ttyUSB0')

print ser.name

# while True:
a = 0b00000001
print a
sent = ser.write(a)
print "a =", bin(a)

#x = ser.read()       

#print "result =", bin(ord(x))

ser.close()