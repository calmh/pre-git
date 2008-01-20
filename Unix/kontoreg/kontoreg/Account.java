package kontoreg;

class Account {
        int account_id;
        int account_type;
        String account_name;
        String account_password;
        String account_email;
        String account_host;
        String account_comment;
        String owner_name;
        String owner_phone;

        public Account(int ai, int at, String an, String ap, String ae,
                        String ah, String ac, String on, String op) {
                account_id = ai;
                account_type = at;
                account_name = an;
                account_password = ap;
                account_email = ae;
                account_host = ah;
                account_comment = ac;
                owner_name = on;
                owner_phone = op;
        }

        public Object[] getArray() {
                Object[] tmp = { new Integer(account_id), new Integer(account_type), account_name, account_password, account_email, account_host, account_comment, owner_name, owner_phone };
                return tmp;
        }
}
