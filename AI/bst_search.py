class Node:
    def __init__(self, data):
        self.left = None
        self.right = None
        self.data = data

def search(root, key):
    # Fungsi untuk mencari nilai dalam BST
    if root is None or root.data == key:
        return root
    if root.data < key:
        return search(root.right, key)
    else:
        return search(root.left, key)

# Contoh penggunaan
root = Node(50)
root.left = Node(30)
root.right = Node(70)
root.left.left = Node(20)
root.left.right = Node(40)

found = search(root, 40)
if found:
    print("Nilai ditemukan")
else:
    print("Nilai tidak ditemukan")

    