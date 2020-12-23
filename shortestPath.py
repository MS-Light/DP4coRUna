import cv2
from skimage import color
import numpy as np
import sys

#img = cv2.imread('result.png')
'''
def on_EVENT_LBUTTONDOWN(event, x, y, flags, param):
    if event == cv2.EVENT_LBUTTONDOWN:
        xy = "%d,%d" % (x, y)
        a.append(x)
        b.append(y)
        cv2.circle(img, (x, y), 1, (0, 0, 255), thickness=-1)
        cv2.putText(img, xy, (x, y), cv2.FONT_HERSHEY_PLAIN,
                    1.0, (0, 0, 0), thickness=1)
        cv2.imshow("image", img)
        print(x, y)
        pixel = [x, y]
        c.append(pixel)
        print(pixel)


cv2.namedWindow("image")
cv2.setMouseCallback("image", on_EVENT_LBUTTONDOWN)
cv2.setMouseCallback("image", on_EVENT_LBUTTONDOWN)
cv2.imshow("image", img)
cv2.waitKey(0)
'''
#left_up 
x1 = int(sys.argv[1]) #c[0][0]
y1 = int(sys.argv[2]) #c[0][1]
x2 = int(sys.argv[3]) #c[1][0]
y2 = int(sys.argv[4]) #c[1][1]
#print(x1, x2, y1, y2)
a = []
b = []
c = []  # list of location
image = cv2.imread("result.png")

image = color.rgb2gray(image)
rows, columns = image.shape
distance = rows ** 2 + columns ** 2
for x in range(0, rows - 1):
    for y in range(0, columns - 1):
        if image[x][y] == 1:
            distance1 = (x1 - x) ** 2 + (y1 - y) ** 2
            if distance1 <= distance:
                distance = distance1
                startPoint = (x, y)

distance = rows ** 2 + columns ** 2
for x in range(0, rows - 1):
    for y in range(0, columns - 1):
        if image[x][y] == 1:
            distance2 = (x2 - x) ** 2 + (y2 - y) ** 2
            if distance2 <= distance:
                distance = distance2
                destination = (x, y)

#print(startPoint, destination)


simple = ((0, 0), rows * columns)
array = []
for x in range(0, rows - 1):
    for y in range(0, columns - 1):
        array.append(simple)
discovered = [(-1, -1)]
reached = [startPoint]
reached2 = [0]
l = list(array[startPoint[0] * columns + startPoint[1]])
l[1] = 0
array[startPoint[0] * columns + startPoint[1]] = tuple(l)



while reached and (destination not in discovered):
    minLocation = reached2.index(min(reached2))
    current = reached[minLocation]
    #print(minLocation)
    reached.pop(minLocation)
    value = reached2.pop(minLocation)

    if image[current[0] - 1][current[1]] == 1:
        if ((current[0] - 1, current[1]) not in discovered) and ((current[0] - 1, current[1]) not in reached):
            reached.append((current[0] - 1, current[1]))
            if array[(current[0] - 1) * columns + current[1]][1] > array[current[0] * columns + current[1]][1] + 1:
                l1 = list(array[(current[0] - 1) * columns + current[1]])
                l1[1] = array[current[0] * columns + current[1]][1] + 1
                l1[0] = current
                array[(current[0] - 1) * columns + current[1]] = tuple(l1)
            reached2.append(array[(current[0] - 1) * columns + current[1]][1])

    if image[current[0] - 1][current[1] - 1] == 1:
        if ((current[0] - 1, current[1] - 1) not in discovered) and ((current[0] - 1, current[1] - 1) not in reached):
            reached.append((current[0] - 1, current[1] - 1))
            if array[(current[0] - 1) * columns + current[1] - 1][1] > array[current[0] * columns + current[1]][1] + 1:
                l2 = list(array[(current[0] - 1) * columns + current[1] - 1])
                l2[1] = array[current[0] * columns + current[1]][1] + 1
                l2[0] = current
                array[(current[0] - 1) * columns + current[1] - 1] = tuple(l2)
            reached2.append(array[(current[0] - 1) * columns + current[1] - 1][1])

    if image[current[0] - 1][current[1] + 1] == 1:
        if ((current[0] - 1, current[1] + 1) not in discovered) and ((current[0] - 1, current[1] + 1) not in reached):
            reached.append((current[0] - 1, current[1] + 1))
            if array[(current[0] - 1) * columns + current[1] + 1][1] > array[current[0] * columns + current[1]][1] + 1:
                l3 = list(array[(current[0] - 1) * columns + current[1]+1])
                l3[1] = array[current[0] * columns + current[1]][1] + 1
                l3[0] = current
                array[(current[0] - 1) * columns + current[1]+1] = tuple(l3)
            reached2.append(array[(current[0] - 1) * columns + current[1] + 1][1])

    if image[current[0]][current[1] - 1] == 1:
        if ((current[0], current[1] - 1) not in discovered) and ((current[0], current[1] - 1) not in reached):
            reached.append((current[0], current[1] - 1))
            if array[(current[0]) * columns + current[1] - 1][1] > array[current[0] * columns + current[1]][1] + 1:
                l4 = list(array[(current[0]) * columns + current[1]-1])
                l4[1] = array[current[0] * columns + current[1]][1] + 1
                l4[0] = current
                array[(current[0]) * columns + current[1]-1] = tuple(l4)
            reached2.append(array[(current[0]) * columns + current[1] - 1][1])

    if image[current[0]][current[1] + 1] == 1:
        if ((current[0], current[1] + 1) not in discovered) and ((current[0], current[1] + 1) not in reached):
            reached.append((current[0], current[1] + 1))
            if array[(current[0]) * columns + current[1] + 1][1] > array[current[0] * columns + current[1]][1] + 1:
                l5 = list(array[(current[0]) * columns + current[1]+1])
                l5[1] = array[current[0] * columns + current[1]][1] + 1
                l5[0] = current
                array[(current[0]) * columns + current[1]+1] = tuple(l5)
            reached2.append(array[(current[0]) * columns + current[1] + 1][1])

    if image[current[0] + 1][current[1] - 1] == 1:
        if ((current[0] + 1, current[1] - 1) not in discovered) and ((current[0] + 1, current[1] - 1) not in reached):
            reached.append((current[0] + 1, current[1] - 1))
            if array[(current[0] + 1) * columns + current[1] - 1][1] > array[current[0] * columns + current[1]][1] + 1:
                l6 = list(array[(current[0] + 1) * columns + current[1] - 1])
                l6[1] = array[current[0] * columns + current[1]][1] + 1
                l6[0] = current
                array[(current[0] + 1) * columns + current[1] - 1] = tuple(l6)
            reached2.append(array[(current[0] + 1) * columns + current[1] - 1][1])

    if image[current[0] + 1][current[1]] == 1:
        if ((current[0] + 1, current[1]) not in discovered) and ((current[0] + 1, current[1]) not in reached):
            reached.append((current[0] + 1, current[1]))
            if array[(current[0] + 1) * columns + current[1]][1] > array[current[0] * columns + current[1]][1] + 1:
                l7 = list(array[(current[0] + 1) * columns + current[1]])
                l7[1] = array[current[0] * columns + current[1]][1] + 1
                l7[0] = current
                array[(current[0] + 1) * columns + current[1]] = tuple(l7)
            reached2.append(array[(current[0] + 1) * columns + current[1]][1])

    if image[current[0] + 1][current[1] + 1] == 1:
        if ((current[0] + 1, current[1] + 1) not in discovered) and ((current[0] + 1, current[1] + 1) not in reached):
            reached.append((current[0] + 1, current[1] + 1))
            if array[(current[0] + 1) * columns + current[1] + 1][1] > array[current[0] * columns + current[1]][1] + 1:
                l8 = list(array[(current[0] + 1) * columns + current[1] + 1])
                l8[1] = array[current[0] * columns + current[1]][1] + 1
                l8[0] = current
                array[(current[0] + 1) * columns + current[1] + 1] = tuple(l8)
            reached2.append(array[(current[0] + 1) * columns + current[1] + 1][1])

    discovered.append(current)
    #print(discovered)
    #print(reached)
    #print(reached2)

if array[destination[0]*columns + destination[1]][1] == rows * columns:
    print("false")
    #print("start", startPoint, "final", destination)
else:
    ptr1 = destination
    ptr2 = array[destination[0]*columns + destination[1]][1]
    result = []
    while ptr2 != 0:
        result.append(ptr1)
        ptr1 = array[ptr1[0]*columns + ptr1[1]][0]
        ptr2 = array[ptr1[0]*columns + ptr1[1]][1]
        result.append(ptr1)
    #print("result")
    print(result)
    #print("start", startPoint, "final", destination)

'''
img = cv2.imread('mall3.jpg')
for i in result:
    img[i[0]][i[1]] = [255, 0, 0]

cv2.imwrite("finalResult.png", img)
'''