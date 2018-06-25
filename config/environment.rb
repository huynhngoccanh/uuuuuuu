# Load the rails application
require File.expand_path('../application', __FILE__)

#custom config settings
$auction_budget_options = [
  'unknown',
  '0 - 500$',
  '500 - 2000$',
  '2000 - 5000$',
  '5000 - 10000$',
  '10000+$',
  'custom'
]

$times_of_day = ['Morning', 'Afternoon', 'Evening']

$contact_ways = ['Email', 'Phone', 'Both']

$pj_api_key = 'b7139aaa17bebda81b23bddb2040ed9c702294bf443aadd7d8f3dba159a3a9c4'
$pj_base_url = "http://api.pepperjamnetwork.com/20120402"
$pj_publisher_id = '116093'

$ir_account_sid = "IRJ9df9uNHqv121676BbeSNsfRDonsmtX1"
$ir_auth_token  = "fUyqYXHgmakjNSRy4ve3z3x3HPZabghx"
$ir_account_sid_two = "IRZAMjNsAfH946535bRU6jf36XdsDE7LT1"
$ir_auth_token_two  = "CCuWjvftfZe6JK7q7BCgwx88MdggZATw"
$ir_api_version  = "4"
$ir_base_url = "https://api.impactradius.com"

#$cj_api_key = "009c4537eb21769a802c2156d62b6fe838d7db808649d8c17e8498a808182ccda56e0a3f6563fe8ccf3c5875b3fba726a39ee23b88cdb63291fe12627460d1dae1/2aa739fc13c62ba59066092dabed7f950456055ea20967c700aa2a330b662f3aea46f33ab9d91de6fa90bb59e973a08485190f73f313c55259a90cf5e80ca801"
# $cj_api_key = '00b0588d95f30799e031d6d5f813dccbcde85632b07116780fb3823f08598b475b30794a663210c56fe9b950ea563d216196392e87c5ea2755702c7baf8705f9a3/2ce49e46ca33e92c7603a73d1c715d40f220df8ea37b80dd1e69cdfa26319adc621401d8914e3f5f302a5a61c49a9b3af74d0dbcad93db80d1280b93745df921'
#$cj_api_key = '00c784300d585eca6fed66d0420b83ea74b55b5e4a6d5d6bd4d27b095961ee8b3cde5dc13c1691913573ffb9f467fc48efd8d12eff622b3448dfb97c0bd80dd91b/443c536add045e5bf567aa664c25ebb3caaadb0ebd64ac12778218ea76f1ecb0640df14364c67651728c7a2541bf3202d61ea5a8d2ed09ff87fe1bd249243971'
$cj_api_key = '008e903b14f9336bb71324d988159978bcdfcf6ca1fcf1e15806aee0ad6cc29e0870bfde4866eb6f007f6b96dceda481edcbb652ebb25521f35f89a5959ff96aab/7634d90836e88ff3a887f16688a24c1e2f6509a9f6d5880738e35f9fec82220d94d928411d03a5e07545822ccdaaa329da6e046869ecdfe0df1960186be3bc81'
$cj_website_id = "6193768"

$linkshare_publisher_uid = 'lQkoRIBE0Es'
$linkshare_web_token = '3c2a63036e05b520f67fa37af1a5f5bcb6f0266c3141aa5999f751b5d1c5e5f6'
$linkshare_payment_reports_token = '18c2b072fc6535c7cb2ca4706bcf14864511a7d13a7e380dc4bf13776fba39b1'

$avant_affiliate_id = '103761'
$avant_website_id = '123101'
$avant_api_key = 'dee3a3408dfedb7bb1457dba680cbbd7'

$g_cse_cx = '008142377032700671550:s11bcjfmmla'

$soleo_basic_auth = 'MuddleMe-DEV:7LeYOa3I'

$app_store_link = "https://itunes.apple.com/us/app/muddleme-shop-earn-cash-get/id591493337?ls=1&mt=8"

$notify_team = %w(kevin@muddleme.com)


BROWSER_SUPPORTED_IMAGE_MIME_TYPES = [
  'image/jpeg', 'image/pjpeg', 'image/gif', 'image/png', 'image/x-png', 'image/jpg', 'image/svg+xml', 'image/jpeg; charset=UTF-8', 'image/gif; charset=UTF-8', 'image/png; charset=UTF-8'
]

BROWSER_SUPPORTED_VIDEO_MIME_TYPES = [
  'video/mp4', 'video/3gpp', 'video/mpeg', 'video/webm', 'video/ogg'
]

STATE_ABBREVIATIONS = ['AL','AK','AZ','AR','CA','CO','CT','DE','DC','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY']

# Load additional configs here, baceuse we need them in environment configs
SOCIAL_CONFIG = YAML.load_file("#{Rails.root}/config/social.yml")[Rails.env]
HOSTNAME_CONFIG = YAML.load_file("#{Rails.root}/config/hostname.yml")[Rails.env]


# Initialize the rails application
MuddleMe::Application.initialize!
