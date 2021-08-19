n = int(input())

prev = int(input())
sig_p = 0
sig_n = 0
ans = 1


for i in range(n-1):
	now = int(input())
	if prev<now:
		sig_n = 1

	if prev>now:
		sig_n = -1

	if sig_p!=sig_n:
		ans = ans+1

	sig_p=sig_n
	prev=now

print('ans: ', ans)




