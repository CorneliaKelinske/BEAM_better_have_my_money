# BEAMBetterHaveMyMoney

This application allows the user to send and receive money between different users and different currencies.
A live exchange rate is available via the AlphaVantage server.

##  How to run this application

In case you don't have an ARM processor, run the start bash script to start the AlphaVantage server:
`./start.sh`

(Otherwise, just run the second command in the bash script: `sudo docker run -p 4001:4000 -it mikaak/alpha-vantage:latest`)

And then
`iex -S mix`

