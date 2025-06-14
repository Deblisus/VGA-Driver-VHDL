import cv2

img = cv2.imread("UTCN230x250.png", cv2.IMREAD_COLOR)

file = open("UTCN230x250.txt", "w")


def map_range(v, a, b, c, d):
       return (v-a) / (b-a) * (d-c) + c

def print_pixel(pixel):
    for color in pixel:
        p2 = 8
        while p2:
            print(int(bool(color & p2)), end='')
            file.write(str(int(bool(color & p2))))
            p2 = int(p2 / 2)
    file.write("\n")
    print()

for row in img:
    for pixel in row:
        '''
        pixel = [color + 1 for color in pixel]
        pixel = [color / 16 for color in pixel]
        pixel = [int(color - 1) for color in pixel]
        '''
        pixel = pixel[::-1]
        pixel = [int(map_range(color, 0, 255, 0, 15)) for color in pixel]

        print_pixel(pixel)