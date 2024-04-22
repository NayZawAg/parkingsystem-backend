## リクエストヘッダーに設定するシークレットトークンは、HMAC-SHA256を使用する
### Ruby暗号化されたパラメータとシークレットキー
### 参考リンク:https://ruby-doc.org/stdlib-2.4.0/libdoc/openssl/rdoc/OpenSSL/HMAC.html#method-c-digest
### OpenSSL::HMAC
<p>OpenSSL::HMAC を使用すると、ハッシュベースのメッセージ認証コード (HMAC) を計算できます。これは、ハッシュ関数とキーの組み合わせを含むメッセージ認証コード (MAC) の一種です。[HMAC](https://ruby-doc.org/stdlib-2.4.0/libdoc/openssl/rdoc/OpenSSL/HMAC.html)を使用して、メッセージの完全性と信頼性を検証できます。</p>

<p>OpenSSL::HMAC はOpenSSL::Digestと同様のインターフェースを持っています。</p>

### digest(digest, key, data) → aString
<p>認証コードをバイナリ文字列として返します。digestパラメータは 、使用するダイジェスト アルゴリズムを指定します。これは、アルゴリズム名またはOpenSSL::Digestのインスタンスを表す文字列です。</p>
<div><p>Ruby Example:</p></div>

```Ruby
require 'openssl'
require 'base64'
require 'json'

# Define your secret key
key = '39e991a558cffc31a472fec75a5c83e603dfa95955a4d6932fcb3529a7f32b7a'

# Encrypt the data
params = 'from_year_month=2023-01&to_year_month=2023-01'
digest = OpenSSL::HMAC.digest('SHA256', params, key)
encrypted_data = Base64.strict_encode64(digest)
puts encrypted_data

url = "https://miyoshibackend.azurewebsites.net/api/v1/downloads/chatbots?#{params}"

response = `curl -H "access-token: #{encrypted_data}" "#{url}"`

puts JSON.parse(response)
```