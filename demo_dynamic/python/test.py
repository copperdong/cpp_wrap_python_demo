import rect

pyRect = rect.PyRectangle(100, 100, 300, 500)
width, height = pyRect.get_size()
print("size: width = %d, height = %d" % (width, height))