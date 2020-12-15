#Plot frequency and phase response
def mfreqz(b, a=1):
    w, h = signal.freqz(b,a)
    h_dB = 20 * np.log10 (abs(h))
    plt.subplot(211)
    plt.plot(w / max(w), h_dB)
    plt.ylim(-150, 5)
    plt.ylabel('Magnitude (db)')
    plt.xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    plt.title(r'Frequency response')
    plt.subplot(212)
    h_Phase = np.unwrap(np.arctan2(np.imag(h), np.real(h)))
    plt.plot(w/max(w),h_Phase)
    plt.ylabel('Phase (radians)')
    plt.xlabel(r'Normalized Frequency (x$\pi$rad/sample)')
    plt.title(r'Phase response')
    plt.subplots_adjust(hspace=0.5)
    
def LMS(x, d, M, mu):
  x = np.expand_dims(x, axis=1)
  d = np.expand_dims(d, axis=1)

  Nx = x.shape[0]

  w = np.zeros((M + 1, 1))

  W = np.zeros((Nx - M, M + 1))
  E = np.zeros((Nx - M, 1))

  for k in np.arange(M, Nx): 
      if (k == M):
        Xbar = x[k::-1]
      else:
        Xbar = x[k:k - M - 1: -1]
      y = np.dot(np.transpose(w) , Xbar)
      e = d[k] - y
      w += 2 * mu * e * Xbar
      W[k - M, :] = np.transpose(w)
      E[k - M] = e

  return W, E
  
def NLMS(x, d, M, beta):
  x = np.expand_dims(x, axis=1)
  d = np.expand_dims(d, axis=1)

  Nx = x.shape[0]

  w = np.zeros((M + 1, 1))

  W = np.zeros((Nx - M, M + 1))
  E = np.zeros((Nx - M, 1))

  for k in np.arange(M, Nx): 
      if (k == M):
        Xbar = x[k::-1]
      else:
        Xbar = x[k:k - M - 1: -1]
      y = np.dot(np.transpose(w) , Xbar)
      e = d[k] - y
      w += 2 * beta * e * Xbar / np.linalg.norm(Xbar)
      W[k - M, :] = np.transpose(w)
      E[k - M] = e

  return W, E
  
def CleanSignals(values):
  green = values['GREEN']
  red = values['RED']
  black = values['BLACK']

  n = 201
  fs = 32
  ft = signal.firwin(n, cutoff = [1, 4.5], window = "hanning", pass_zero=False, fs=fs)

  green_hpf = signal.lfilter(ft, 1, green, axis=0)
  red_hpf = signal.lfilter(ft, 1, red, axis=0)
  black_hpf = signal.lfilter(ft, 1, black, axis=0)
 
  M = 10
  _, green_af = NLMS(red_hpf[:, 1] + green_hpf[:, 0] + green_hpf[:, 2] + black_hpf[:, 1], green_hpf[:, 1], M, 0.0075)
  _, red_af = NLMS(green_hpf[:, 0] + red_hpf[:, 1] + red_hpf[:, 2] + black_hpf[:, 0], red_hpf[:, 0], M, 0.005)

  return green_af, red_af
  
  
def Analyze(green_af, red_af):
  Nfft = 2048
  Nfft2 = int(Nfft / 2)

  Pg = np.abs(np.fft.fft(green_af , Nfft, axis=0))
  Pr = np.abs(np.fft.fft(red_af , Nfft, axis=0))

  Pg = Pg[:Nfft2, :]
  Pr = Pr[:Nfft2, :]

  freqs = fs * np.arange(Nfft2) / Nfft

  colors = ['red', 'green', 'blue']

  fig, ax = plt.subplots()
  plt.plot(freqs, Pg)

  fig, ax = plt.subplots()
  plt.plot(freqs, Pr)

  Pg_idx = int(np.argmax(Pg))
  print(freqs[Pg_idx] * 60)

  Pr_idx = int(np.argmax(Pr))
  print(freqs[Pr_idx] * 60)

  Pr_max = np.max(Pr)
  Pg_max = np.max(Pg)
  print(Pg_max / Pr_max)  

  
def ComputeHR(green, red):
  Nfft = 2048
  Nfft2 = int(Nfft / 2)

  gg = np.abs(np.fft.fft(green , Nfft, axis=0))
  rr = np.abs(np.fft.fft(red , Nfft, axis=0))

  gg = gg[:Nfft2, :]
  rr = rr[:Nfft2, :]

  fs = 32
  freqs = fs * np.arange(Nfft2) / Nfft

  gg_idx = int(np.argmax(gg)) 
  rr_idx = int(np.argmax(rr))
  
  HR_green = freqs[gg_idx] * 60
  HR_red = freqs[rr_idx] * 60

  #rr_max = np.max(rr)
  #gg_max = np.max(gg)
  #print(gg_max / rr_max)

  return HR_green, HR_red

def main():
    for file_name in files:
      print(file_name)
      path_to_data = os.path.join(path_to_dir, file_name)
      values = GetSignals(path_to_data)
      green, red = CleanSignals(values)
      HR_green, HR_red = ComputeHR(green, red)
      print(HR_green, HR_red)
      print("\n")
        
  
        
