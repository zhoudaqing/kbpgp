
{KeyManager} = require '../../lib/keymanager'
{keys} = require '../data/keys.iced'
{createHash} = require 'crypto'

#============================================================================

test = (who, expected, T,cb) ->
  raw = keys[who]
  await KeyManager.import_from_armored_pgp { raw }, defer err, km
  T.no_error err
  T.assert km?, "a key manager came back"
  userids = km.get_userids_mark_primary()
  primary = null
  for u in userids 
    if u.primary 
      primary = u
      break
  h = null
  if primary?
    h = createHash('SHA256').update(primary.utf8()).digest('hex')
  T.equal h, expected, "got the right primary UID"
  cb()

exports.test_gmax = (T, cb) ->
  await test "gmax", "c82219629a4dd0283fd3d0d1129cca58ac0c8d45d6d0b40c1acda50a8991fb28", T, defer()
  cb()
