import matplotlib.pyplot as plt
import librosa
import IPython.display as ipd
import statsmodels.api as sm
from scipy.signal import find_peaks

#The voice file
audio_file = 'nice-work.wav'
ipd.Audio(audio_file)

# A handwritten function to get the frequency of a frame
def getFreq(arr, rate):
    index = 0
    j = arr[0]
    if j>0:
        while j>=0:
            index+=1
            j=arr[index]
    while j <= 0:
        index += 1
        j = arr[index]
    max1=j
    index1=index
    while j>=0:
        index+=1
        j=arr[index]
        if j>max1:
            max1=j
            index1=index
    while j <= 0:
        index += 1
        j = arr[index]
    index2=index
    max2=j
    while j>=0:
        index += 1
        j = arr[index]
        if j > max2:
            max2 = j
            index2 = index
    timeForArray = index2 - index1
    time = timeForArray/rate
    freq =  1/ time
    return freq

# store the samples of the voice with the sampling frequency value
data, rate = librosa.load(audio_file)

print(rate)
print(len(data))

# i is a counter for the frames, and the other two are counters for the male and female frames
i=0
male=0
female=0

# This loop goes on the voice samples to cut them in an overlaped frames
while i < (len(data) - 441) :
  frame=data[i:i+441] #overlap 10mw for rach frame
  auto = sm.tsa.acf(frame, nlags=441)
  peaks = find_peaks(auto)[0]  # Find peaks of the autocorrelation
  try:
      lag = peaks[1]  # Choose the first peak as our pitch component lag
      pitch = rate / lag # Pitch frequency
      if pitch<255 and pitch>=165: # Female range
          female+=1
      elif pitch<155 and pitch>85: # Male range
          male+=1
      #freq = getFreq(auto, rate)
  except:
      print("Value can't be taken")
  i = int(i + 220)

if male>female:
    print("This is a voice of a male")
else:
    print("This is a voice of a female")

# plot the original signal
#pd.Series(data).plot()
plt.plot(data)
title=audio_file.split('.')[0] + " Voice"
title = title.capitalize()
plt.title(title)
#plot_acf(data)
plt.show()
