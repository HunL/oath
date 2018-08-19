var web3Provider = null;
var OathContract;
const nullAddress = "0x0000000000000000000000000000000000000000";

function init() {
  // We init web3 so we have access to the blockchain
  initWeb3();
}

function initWeb3() {
  if (typeof web3 !== 'undefined' && typeof web3.currentProvider !== 'undefined') {
    web3Provider = web3.currentProvider;
    web3 = new Web3(web3Provider);
  } else {    
    console.error('No web3 provider found. Please install Metamask on your browser.');
    alert('No web3 provider found. Please install Metamask on your browser.');
  }
  
  // we init The Oath contract infos so we can interact with it
  initOathContract();
}

function initOathContract() {
  $.getJSON('Oath.json', function(data) {
    // Get the necessary contract artifact file and instantiate it with truffle-contract
    OathContract = TruffleContract(data);

    // Set the provider for our contract
    OathContract.setProvider(web3Provider);

    // listen to the events emitted by our smart contract
    getEvents ();

    // We'll retrieve the Voterrs addresses set in our contract using Web3.js
    getFirstVoterAddress();
    getSecondVoterAddress();
  });
}

function getEvents () {
  OathContract.deployed().then(function(instance) {
  var events = instance.allEvents(function(error, log){
    if (!error)
      $("#eventsList").prepend('<li>' + log.event + '</li>'); // Using JQuery, we will add new events to a list in our index.html
  });
  }).catch(function(err) {
    console.log(err.message);
  });
}

function getFirstVoterAddress() {
  OathContract.deployed().then(function(instance) {
    return instance.voter1.call();
  }).then(function(result) {
    $("#voter1").text(result); // Using JQuery again, we will modify the html tag with id voter1 with the returned text from our call on the instance of the oath contract we deployed
  }).catch(function(err) {
    console.log(err.message);
  });
}

function getSecondVoterAddress() {
  OathContract.deployed().then(function(instance) {
    return instance.voter2.call();
  }).then(function(result) {
    if(result != nullAddress) {
      $("#voter2").text(result);
      $("#registerToFight").remove(); // By clicking on the button with the ID registerToFight, a user can register as second voter, so we need to remove the button if a second voter is set 
    } else {
      $("#voter2").text("Undecided, you can register to vote in this event!");
    }   
  }).catch(function(err) {
    console.log(err.message);
  });
}

function registerAsSecondVoter () {
  web3.eth.getAccounts(function(error, accounts) {
  if (error) {
    console.log(error);
  } else {
    if(accounts.length <= 0) {
      alert("No account is unlocked, please authorize an account on Metamask.")
    } else {
      OathContract.deployed().then(function(instance) {
        return instance.registerAsAnOpponent({from: accounts[0]});
      }).then(function(result) {
        console.log('Registered as an opponent')
        getSecondVoterAddress();
      }).catch(function(err) {
        console.log(err.message);
      });
    }
  }
  });
}

// When the page loads, this will call the init() function
$(function() {
  $(window).load(function() {
    init();
  });
});
