import xlrd
import numpy as np
import matplotlib.pyplot as plt

readme = open('./data/README.txt', 'r')
count = 0
#index = []
for line in readme:
	count += 1

def getrowdata():
	data = xlrd.open_workbook('./data/results.xls')
	table = data.sheets()[0]

	rowdata = np.zeros((table.nrows - 1, table.ncols - 1))

	for rownum in range(1, table.nrows):
		for colnum in range(1, table.ncols):
			rowdata[rownum - 1, colnum - 1] = float(table.row_values(rownum)[colnum][0])
	return rowdata

def get_MOS_rowdata(data):
	MOS = np.sum(data, axis=0) / len(data)
	MOS_rowdata = np.row_stack((data, MOS))
	return MOS_rowdata


def getindex(mos_and_rowdata):
	index = range(len(mos_and_rowdata))
	index = np.array(index)
	return index


def getpearson(mos_and_rowdata):
	tmpcorr = np.corrcoef(mos_and_rowdata)
	pearson = tmpcorr * 0.5 + 0.5
	return pearson[-1,:]

if __name__ == '__main__':
	rowdata = getrowdata()
	MOS_rowdata = get_MOS_rowdata(rowdata)
	pearsoncorr = getpearson(MOS_rowdata)
	uslesssubjext = getindex(MOS_rowdata)[pearsoncorr < 0.51]
	new_rowdata = np.delete(MOS_rowdata, uslesssubjext, 0)
	print('unuseful test is ', uslesssubjext)
	new_MOS_rowdata = get_MOS_rowdata(new_rowdata)
	print(new_MOS_rowdata.shape)
	MOS = new_MOS_rowdata[-1, :]
	newpearsoncorr = getpearson(new_MOS_rowdata)
	print('new pearsoncorr are ', newpearsoncorr, '\n')
	while(len(uslesssubjext)>3):
		new_rowdata = np.delete(new_rowdata, uslesssubjext, 0)
		new_MOS_rowdata = get_MOS_rowdata(new_rowdata)
		print('the shape of new rowdata is:', new_MOS_rowdata.shape)

		MOS = new_MOS_rowdata[-1, :]
		print('the new MOS are: ', MOS)
		newpearsoncorr = getpearson(new_MOS_rowdata)
		print('new pearsoncorr are ', newpearsoncorr, '\n')

		uslesssubjext = getindex(new_MOS_rowdata)[newpearsoncorr < 0.7]


	#print(MOS)

	plt.figure()
	plt.boxplot(new_rowdata)

	plt.figure()
	plt.plot(range(len(MOS)), MOS)
	plt.show()

