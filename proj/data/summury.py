# coding = 'utf-8'
author = 'Sen Wang'

import glob


def summary(indexpath):
	filedict = {}
	for filename in glob.glob(indexpath + '*.txt'):
		file = open(filename, 'r')
		count = 0
		for line in file:
			if line[0] != 'y':
				continue

			print(line)
			count += 1
		print(count)
		filedict[filename] = count

	outfile = open('summary.txt', 'w')

	for key in sorted(filedict.keys()):
		outfile.write(key[2:-1] + ':  '+str(filedict[key]) + '\n')

	return 0


def getLabel(indexpath, filename):
	labels = []
	file = open(indexpath + filename, 'r')
	count = 0
	for line in file:
		if line[0] != 'y':
			continue
		label = line[59:61]

		labels.append(label)
		count += 1
		print(label)
	print('total num is: ', count)
	labelpath = './label/'
	outfile = open(labelpath + 'Tennis' + '_lable.txt', 'w')
	for i in range(len(labels)):
		outfile.write(labels[i] + '\n')
	return 0


if __name__ == '__main__':
	indexpath = './index/'
	filename = 'Tennis.txt'
	getLabel(indexpath, filename)