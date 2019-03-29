import serial

ser = serial.Serial('/dev/ttyUSB0')

print ser.name

# Start Signal
a = 0b00000001
print a
sent = ser.write(a)
print "a =", bin(a)

#-----------------1era INSTRUCCION-----------------#
# LSB 1
a = 0b11011101
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 2
a = 0b11001100
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 3
a = 0b10111011
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 4
a = 0b10101010
print a
sent = ser.write(a)
print "a =", bin(a)

#-----------------2da INSTRUCCION-----------------#
# LSB 1
a = 0b01000100
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 2
a = 0b00110011
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 3
a = 0b00100010
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 4
a = 0b00010001
print a
sent = ser.write(a)
print "a =", bin(a)

#-----------------HALT INSTRUCCION-----------------#
# LSB 1
a = 0b11111111
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 2
a = 0b11111111
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 3
a = 0b11111111
print a
sent = ser.write(a)
print "a =", bin(a)
# LSB 4
a = 0b11111111
print a
sent = ser.write(a)
print "a =", bin(a)

#-----------------Continuous Signal-----------------#
a = 0b00000010
print a
sent = ser.write(a)
print "a =", bin(a)

x = ser.read()       

print "result =", bin(ord(x))


ser.close()
