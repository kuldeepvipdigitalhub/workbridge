class Config:
    SECRET_KEY = "supersecretkey"
    SQLALCHEMY_DATABASE_URI = "postgresql://wbuser:572128@localhost/workbridge"
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Razorpay
    RAZORPAY_KEY_ID = "rzp_test_SSCIqPnsaC1ciN"
    RAZORPAY_SECRET = "YeGpTqnOJJwbVBJY2aUaCYuH"