#region All Namespaces

using System;
using System.Data;
using System.Text;
using MySql.Data.MySqlClient;

#endregion All Namespaces


public class Advance_Room_Booking
{
    #region All Memory Variables
    private string _ID;
    private string _PatientID;
    private DateTime _BookingDate;
    private string _IPDCaseType_ID;
    private string _Room_ID;
    private string _IPDCaseType_ID_Bill;
    private string _DoctorID;
    private string _EntryBy;
    private string _Remarks;
    private int _CentreID;
    private int _panelID;
    private int _approvalAmount;

    private string _policyNo;

    public string PolicyNo
    {
        get { return _policyNo; }
        set { _policyNo = value; }
    }

    private DateTime _expiryDate;

    public DateTime ExpiryDate
    {
        get { return _expiryDate; }
        set { _expiryDate = value; }
    }

    private string _policyCardNo;

    public string PolicyCardNo
    {
        get { return _policyCardNo; }
        set { _policyCardNo = value; }
    }

    private string _nameOnCard;

    public string NameOnCard
    {
        get { return _nameOnCard; }
        set { _nameOnCard = value; }
    }

    private string _cardHolder;

    public string CardHolder
    {
        get { return _cardHolder; }
        set { _cardHolder = value; }
    }

    private int _IgnorePolicy;

    public int IgnorePolicy
    {
        get { return _IgnorePolicy; }
        set { _IgnorePolicy = value; }
    }

    private string _IgnorePolicyReason;

    public string IgnorePolicyReason
    {
        get { return _IgnorePolicyReason; }
        set { _IgnorePolicyReason = value; }
    }

    private string _approvalRemark;

    public string ApprovalRemark
    {
        get { return _approvalRemark; }
        set { _approvalRemark = value; }
    }

    private string _admissionType;

    public string admissionType
    {
        get { return _admissionType; }
        set { _admissionType = value; }
    }

    private string _referedSource;

    public string referedSource
    {
        get { return _referedSource; }
        set { _referedSource = value; }
    }
    

    #endregion

    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion

    #region Overloaded Constructor
    public Advance_Room_Booking()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public Advance_Room_Booking(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #endregion

    #region Set All Property
    public string ID
    {
        get { return _ID; }
        set { _ID = value; }
    }

    public string PatientID
    {
        get { return _PatientID; }
        set { _PatientID = value; }
    }

    public DateTime BookingDate
    {
        get { return _BookingDate; }
        set { _BookingDate = value; }
    }

    public string IPDCaseType_ID
    {
        get { return _IPDCaseType_ID; }
        set { _IPDCaseType_ID = value; }
    }

    public string Room_ID
    {
        get { return _Room_ID; }
        set { _Room_ID = value; }
    }

    public string IPDCaseType_ID_Bill
    {
        get { return _IPDCaseType_ID_Bill; }
        set { _IPDCaseType_ID_Bill = value; }
    }

    public string DoctorID
    {
        get { return _DoctorID; }
        set { _DoctorID = value; }
    }

    public string EntryBy
    {
        get { return _EntryBy; }
        set { _EntryBy = value; }
    }

    public string Remarks
    {
        get { return _Remarks; }
        set { _Remarks = value; }
    }

    public int CentreID
    {
        get { return _CentreID; }
        set { _CentreID = value; }
    }

    public int PanelID
    {
        get { return _panelID; }
        set { _panelID = value; }
    }
    public int ApprovalAmount
    {
        get { return _approvalAmount; }
        set { _approvalAmount = value; }
    }




    #endregion

    #region All Public Member Function
    public string Insert()
    {
        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Advance_Room_Booking");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            this.PatientID = Util.GetString(PatientID);
            this.BookingDate = Util.GetDateTime(BookingDate);
            this.IPDCaseType_ID = Util.GetString(IPDCaseType_ID);
            this.Room_ID = Util.GetString(Room_ID);
            this.IPDCaseType_ID_Bill = Util.GetString(IPDCaseType_ID_Bill);
            this.DoctorID = Util.GetString(DoctorID);
            this.EntryBy = Util.GetString(EntryBy);
            this.Remarks = Util.GetString(Remarks);
            this.CentreID = Util.GetInt(CentreID);
            this.referedSource = Util.GetString(referedSource);
            this.admissionType = Util.GetString(admissionType);
            this.PanelID = Util.GetInt(PanelID);
            this.ApprovalAmount = Util.GetInt(ApprovalAmount);
            this.ApprovalRemark = Util.GetString(ApprovalRemark);
            this.PolicyNo = Util.GetString(PolicyNo);
            this.ExpiryDate =ExpiryDate ;
            this.PolicyCardNo = Util.GetString(PolicyCardNo);
            this.NameOnCard = Util.GetString(NameOnCard);
            this.CardHolder = Util.GetString(CardHolder);
            this.IgnorePolicy = Util.GetInt(IgnorePolicy);
            this.IgnorePolicyReason = Util.GetString(IgnorePolicyReason);


            cmd.Parameters.Add(new MySqlParameter("@vPatientID", PatientID));
            cmd.Parameters.Add(new MySqlParameter("@vBookingDate", BookingDate));
            cmd.Parameters.Add(new MySqlParameter("@vIPDCaseTypeID", IPDCaseType_ID));
            cmd.Parameters.Add(new MySqlParameter("@vRoomId", Room_ID));
            cmd.Parameters.Add(new MySqlParameter("@vIPDCaseTypeID_Bill", IPDCaseType_ID_Bill));
            cmd.Parameters.Add(new MySqlParameter("@vDoctorID", DoctorID));
            cmd.Parameters.Add(new MySqlParameter("@vEntryBy", EntryBy));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Remarks));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID", CentreID));
            cmd.Parameters.Add(new MySqlParameter("@vAdmissionType", admissionType));
            cmd.Parameters.Add(new MySqlParameter("@vReferedSource", referedSource));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", PanelID));
            cmd.Parameters.Add(new MySqlParameter("@vApprovalAmount", ApprovalAmount));
            cmd.Parameters.Add(new MySqlParameter("@vApprovalRemark", ApprovalRemark));
            cmd.Parameters.Add(new MySqlParameter("@vPolicyNo", PolicyNo));
            cmd.Parameters.Add(new MySqlParameter("@vExpiryDate", ExpiryDate));
            cmd.Parameters.Add(new MySqlParameter("@vPolicyCardNo", PolicyCardNo));
            cmd.Parameters.Add(new MySqlParameter("@vNameOnCard", NameOnCard));
            cmd.Parameters.Add(new MySqlParameter("@vCardHolder", CardHolder));
            cmd.Parameters.Add(new MySqlParameter("@vIgnorePolicy", IgnorePolicy));
            cmd.Parameters.Add(new MySqlParameter("@vIgnorePolicyReason", IgnorePolicyReason));
            



            ID = cmd.ExecuteScalar().ToString();

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return ID;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            throw (ex);
        }
    }
    #endregion All Public Member Function
}


public class PanelDocument
{
    public int ID { get; set; }
    public string DocumentName { get; set; }
    public string DocumentBase64 { get; set; }
    public string DocumentFileName { get; set; }
    public string DocumentSaveURLPath { get; set; }

}