import gdb

class HeapPrinter:
	def __init__(self, val):
		self.val = val
		self.size = val['size']
		self.cap = val['capacity']
		self.mem = val['heap']

	def make_text(self):

		# yield 'size', self.size

		# yield 'capacity', self.cap


		# for i in range(int(self.cap)):
		# 	try:
		# 		str((self.mem+i).dereference())
		# 		yield '\t'+str(i), str((self.mem+i).dereference())
		# 	except RuntimeError:
		# 		yield '\t'+str(i), 'Null'
		# 	# yield str(i), str((self.mem+i).dereference())

		for field in self.val.type.fields():
			key = field.name
			val = self.val[key]
			if val.type.code == gdb.TYPE_CODE_INT:
				yield key, int(val)
			elif val.type.code == gdb.TYPE_CODE_FLT or val.type.code == gdb.TYPE_CODE_DECFLOAT:
				yield key, float(val)
			elif val.type.code == gdb.TYPE_CODE_STRING or val.type.code == gdb.TYPE_CODE_ARRAY:
				yield key, str(val)
			elif val.type.code == gdb.TYPE_CODE_PTR or val.type.code == gdb.TYPE_CODE_MEMBERPTR:
				if not val: 
					yield key, "NULL"
				else: 
					yield 'Element(s) of heap (starting from 0 indexing)', ''
					for i in range(int(self.cap)):
						try:
							str((self.mem+i).dereference())
							yield '\theap['+str(i)+']', str((self.mem+i).dereference())
						except RuntimeError:
							yield '\theap['+str(i)+']', 'NULL'
			else: 
				yield key, val

	def to_string(self):
		s = int(self.val['size'])
		test = ''
		for i in self.make_text():
			test += str(i[0])+' is '+str(i[1])+'\n'
		return  str(test)

def custom_printer(val):
	if str(val.type) == 'VertexHeap' : return HeapPrinter(val)

gdb.pretty_printers.append(custom_printer)