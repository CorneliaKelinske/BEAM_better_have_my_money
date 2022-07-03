# BeamBetterHaveMyMoney

##  How to run

Install direnv

```
sudo apt install direnv
```
(on Ubuntu Linux)

Create an .envrc file in the root of your project and put in your api key:

```
echo export API_KEY="XXXXXXXXX" > .envrc
```

Allow direnv

```
direnv allow
```

Reload the terminal and run the project

```
iex -S mix
```