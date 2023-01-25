using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using MySql.Data.MySqlClient;
using System.Data;
using System.Text;

/// <summary>
/// Summary description for PreSurgerySummary
/// </summary>
public class PreSurgerySummary
{
    
	public PreSurgerySummary()
	{
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
	}
    public PreSurgerySummary(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #region All Memory Variables
    private int _PreSurgeryID;
    private string _PatientID;
    private string _DiagnosisName;
    private string _ProcedureName;
    private decimal _OtherCharges;
    private decimal _TotalAmt;
    private string _Remark;
    private DateTime _Date;
    private decimal _currencyamount;
    private string _currencynotation;
    private decimal _NetAmount;
    private decimal _DiscountPer;
    private int _IsRejected;
    private DateTime _RejectDate;
    private string _RejectBy;
    private string _Hospital_ID;
    private int _CentreID;
    private string _StayDays;
    private string _SurgeryID;
    private decimal _SurgeryAmount;
    private int _PanelID;
    private string _PolicyNo;
    private string _DiscountReason;
    private string _DiscApprovedBy;
    #endregion
    #region All Global Variables
    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;
    #endregion
    #region Set All Property
    public virtual int PreSurgeryID { get { return _PreSurgeryID; } set { _PreSurgeryID = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string DiagnosisName { get { return _DiagnosisName; } set { _DiagnosisName = value; } }
    public virtual string ProcedureName { get { return _ProcedureName; } set { _ProcedureName = value; } }
    public virtual decimal OtherCharges { get { return _OtherCharges; } set { _OtherCharges = value; } }
    public virtual decimal TotalAmt { get { return _TotalAmt; } set { _TotalAmt = value; } }
    public virtual string Remark { get { return _Remark; } set { _Remark = value; } }
    public virtual DateTime Date { get { return _Date; } set { _Date = value; } }
    public virtual decimal currencyamount { get { return _currencyamount; } set { _currencyamount = value; } }
    public virtual string currencynotation { get { return _currencynotation; } set { _currencynotation = value; } }
    public virtual decimal NetAmount { get { return _NetAmount; } set { _NetAmount = value; } }
    public virtual decimal DiscountPer { get { return _DiscountPer; } set { _DiscountPer = value; } }
    public virtual int IsRejected { get { return _IsRejected; } set { _IsRejected = value; } }
    public virtual DateTime RejectDate { get { return _RejectDate; } set { _RejectDate = value; } }
    public virtual string RejectBy { get { return _RejectBy; } set { _RejectBy = value; } }
    public virtual string Hospital_ID { get { return _Hospital_ID; } set { _Hospital_ID = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string StayDays { get { return _StayDays; } set { _StayDays = value; } }
    public virtual decimal SurgeryAmount { get { return _SurgeryAmount; } set { _SurgeryAmount = value; } }
    public virtual string SurgeryID { get { return _SurgeryID; } set { _SurgeryID = value; } }
    public virtual int PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string PolicyNo { get { return _PolicyNo; } set { _PolicyNo = value; } }
    public virtual string DiscountReason { get { return _DiscountReason; } set { _DiscountReason = value; } }
    public virtual string DiscApprovedBy { get { return _DiscApprovedBy; } set { _DiscApprovedBy = value; } }
    #endregion
    #region All Public Member Function
     public string Insert()
    {
      
        try
        {
            string Output = "";
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_PreSurgeryBookingSummary");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }


            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }

            //MySqlParameter Pre = new MySqlParameter();
            //Pre.ParameterName = "@_PreSurgeryID";

            //Pre.MySqlDbType = MySqlDbType.VarChar;
            //Pre.Size = 50;
            //Pre.Direction = ParameterDirection.Output;
            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;
            this.PatientID = Util.GetString(PatientID);
            this.DiagnosisName = Util.GetString(DiagnosisName);
            this.ProcedureName = Util.GetString(ProcedureName);
            this.OtherCharges = Util.GetDecimal(OtherCharges);
            this.TotalAmt = Util.GetDecimal(TotalAmt);
            this.Remark = Util.GetString(Remark);
            this.Date = Util.GetDateTime(Date);
            this.currencyamount = Util.GetDecimal(currencyamount);
            this.currencynotation = Util.GetString(currencynotation);
            this.NetAmount = Util.GetDecimal(NetAmount);
            this.DiscountPer = Util.GetDecimal(DiscountPer);
            this.Hospital_ID = Util.GetString(Hospital_ID);
            this.CentreID = Util.GetInt(CentreID);
            this.StayDays = Util.GetString(StayDays);
            this.SurgeryID = Util.GetString(SurgeryID);
            this.SurgeryAmount = Util.GetDecimal(SurgeryAmount);
            this.PanelID = Util.GetInt(PanelID);
            this.PolicyNo = Util.GetString(PolicyNo);
            this.DiscountReason = Util.GetString(DiscountReason);
            this.DiscApprovedBy = Util.GetString(DiscApprovedBy);

            cmd.Parameters.Add(new MySqlParameter("@_PatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@_DiagnosisName", Util.GetString(DiagnosisName)));
            cmd.Parameters.Add(new MySqlParameter("@_ProcedureName", Util.GetString(ProcedureName)));
            cmd.Parameters.Add(new MySqlParameter("@_OtherCharges", Util.GetDecimal(OtherCharges)));
            cmd.Parameters.Add(new MySqlParameter("@_TotalAmt", Util.GetDecimal(TotalAmt)));
            cmd.Parameters.Add(new MySqlParameter("@_Remark", Util.GetString(Remark)));
            cmd.Parameters.Add(new MySqlParameter("@_Date", Util.GetDateTime(Date)));
            cmd.Parameters.Add(new MySqlParameter("@_currencyamount", Util.GetDecimal(currencyamount)));
            cmd.Parameters.Add(new MySqlParameter("@_currencynotation", Util.GetString(currencynotation)));
            cmd.Parameters.Add(new MySqlParameter("@_NetAmount", Util.GetDecimal(NetAmount)));
            cmd.Parameters.Add(new MySqlParameter("@_DiscountPer", Util.GetDecimal(DiscountPer)));
            cmd.Parameters.Add(new MySqlParameter("@_Hospital_ID", Util.GetString(Hospital_ID)));
            cmd.Parameters.Add(new MySqlParameter("@_CentreID", Util.GetString(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@_StayDays", Util.GetString(StayDays)));
            cmd.Parameters.Add(new MySqlParameter("@_SurgeryID", Util.GetString(SurgeryID)));
            cmd.Parameters.Add(new MySqlParameter("@_SurgeryAmount", Util.GetDecimal(SurgeryAmount)));
            cmd.Parameters.Add(new MySqlParameter("@_PanelID", Util.GetInt(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@_PolicyNo", Util.GetString(PolicyNo)));
            cmd.Parameters.Add(new MySqlParameter("@_DiscountReason", Util.GetString(DiscountReason)));
            cmd.Parameters.Add(new MySqlParameter("@_DiscApprovedBy", Util.GetString(DiscApprovedBy)));
            Output = cmd.ExecuteNonQuery().ToString();
            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }

            return Output;
        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            // Util.WriteLog(ex);   
            throw (ex);
        }
    }

    #endregion
}