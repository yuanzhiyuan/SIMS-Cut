
import multiprocessing as mp

pool = mp.Pool(4)

def test(x):
	print(x**x)
	return x**x

pool.map(test,range(10))
