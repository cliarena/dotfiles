require('neotest').setup({
  adapters = {
    --[[ require('neotest-jest')({ ]]
    --[[   jestCommand = "npm test --" ]]
    --[[ }), ]]
    require('rustaceanvim.neotest')
  }
})
