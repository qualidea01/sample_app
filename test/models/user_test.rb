require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",
              password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  # user.nameが空白だった場合そのユーザーは有効にしないコード
  test "name should be present" do
    @user.name = " "
    assert_not @user.valid?
  end

  # user.emailが空白だった場合そのユーザーは有効にしないコード
  test "email should be present" do
    @user.email = " "
    assert_not @user.valid?
  end

  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "email validation should accept valid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |valid_address|
      @user.email = valid_address
      assert_not @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end

  test "email addresses should be unique" do
    # 同じ属性のユーザーを作成
    duplicate_user = @user.dup
    # メールアドレスの検証のためにユーザーが入力したメールアドレスを全て大文字に変換する(普通だと大文字小文字の区別ができずテストの意味がないため)
    duplicate_user.email = @user.email.upcase
    # 情報を保存
    @user.save
    # 有効かどうかの確認
    assert_not duplicate_user.valid?
  end

  test "password should be present (nonblank)" do
    @user.password = @user.password_confirmation = " " * 6
    assert_not @user.valid?
  end

  test "password should have minimum length" do
    @user.password = @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end

  test "authenticated? should return false for a user with nil digest" do
    assert_not @user.authenticated?('')
  end
end
