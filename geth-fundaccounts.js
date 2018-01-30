// send funds from etherbase to other accounts
var amount = eth.getBalance(eth.accounts[0]) / eth.accounts.length
console.log("Amount:", web3.fromWei(amount, 'ether'))

eth.accounts.slice(1).forEach(function(acc) { eth.sendTransaction({ from: eth.coinbase, to: acc, value: amount}); });
