import serial

ser = serial.Serial('/dev/ttyUSB0')

print ser.name

# while True:
a = 0b00000010
sent = ser.write(chr(a))
print "a =", bin(a)

b = 0b00000011
sent = ser.write(chr(b))
print "b =", bin(b)

op = 0b100000
sent = ser.write(chr(op))
print "op =", bin(op)

x = ser.read()         

print "result =", bin(ord(x))

ser.close()