import serial

<<<<<<< HEAD
ser = serial.Serial('/dev/ttyUSB0')
=======
ser = serial.Serial('COM6')
>>>>>>> 867004faa6ad069a8c0936b42da9a1c28230bcbc

print ser.name

# while True:
<<<<<<< HEAD
a = 0b00100000
print a
sent = ser.write(a)
print "a =", bin(a)

x = ser.read()       

print "result =", bin(ord(x))
=======
a = 0b01110000
sent = ser.write(chr(a))
print "a =", bin(a)

b = 0b1
sent = ser.write(chr(b))
print "b =", bin(b)

op = 0b100000
sent = ser.write(chr(op))
print "op =", bin(op)

# x = ser.read()         

# print "result =", bin(ord(x))
>>>>>>> 867004faa6ad069a8c0936b42da9a1c28230bcbc

ser.close()