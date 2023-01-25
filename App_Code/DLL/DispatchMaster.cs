using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using MySql.Data.MySqlClient;

/// <summary>
/// Summary description for DispatchMaster
/// </summary>
public class DispatchMaster
{
	public DispatchMaster()
    {
        objCon = Util.GetMySqlCon();
        this.IsLocalConn = true;
    }
    public DispatchMaster(MySqlTransaction objTrans)
    {
        this.objTrans = objTrans;
        this.IsLocalConn = false;
    }
    #region All Memory Variables
    private int _ID;
    private string _Type;
    private string _TransactionID;
    private DateTime _DateOfAdmission;
    private DateTime _DateOfDischarge;
    private string _PName;
    private int _PanelID;
    private string _PanelName;
    private decimal _BillAmount;
    private DateTime _DispatchDate;
    private string _DocketNo;
    private string _Remarks;
    private int _DispatchDayValidity;
    private int _DispatchDayID;
    private string _UserID;
    private string _CourierComp;
    private string _Ref1;
    private string _Ref2;
    private string _PatientID;
    private string _DispatchNo;
    private string _DispatchID;
    private string _panelInvoiceNo;
    private decimal _PanelAmt;
    private string _LedgerTransactionNO;
    private DateTime _BillDate;
    private string _BillNo;
    private string _editBy;
    private DateTime _editDate;
    private decimal _GrossAmount;
    private decimal _DiscAmt;
    private string _policyNo;
    private string _cardNo;
    private int _CentreID;
    private string _IpAddress;
    private string _CoverNoteNo;
    private DateTime _CoverNoteDate;
    private decimal _PanelPaidAmt;
    private decimal _PatientPaybleAmt;
    private decimal _PatientPaidAmt;
    private decimal _OutStanding;
    private decimal _OPDNetAmount;
    private decimal _IPDNetAmount;
    #endregion
    
    #region All Global Variables

    MySqlConnection objCon;
    MySqlTransaction objTrans;
    bool IsLocalConn;

    #endregion
    #region Set All Property
    public virtual int ID { get { return _ID; } set { _ID = value; } }
    public virtual string Type { get { return _Type; } set { _Type = value; } }
    public virtual string TransactionID { get { return _TransactionID; } set { _TransactionID = value; } }
    public virtual DateTime DateOfAdmission { get { return _DateOfAdmission; } set { _DateOfAdmission = value; } }
    public virtual DateTime DateOfDischarge { get { return _DateOfDischarge; } set { _DateOfDischarge = value; } }
    public virtual string PName { get { return _PName; } set { _PName = value; } }
    public virtual int PanelID { get { return _PanelID; } set { _PanelID = value; } }
    public virtual string PanelName { get { return _PanelName; } set { _PanelName = value; } }
    public virtual decimal BillAmount { get { return _BillAmount; } set { _BillAmount = value; } }
    public virtual DateTime DispatchDate { get { return _DispatchDate; } set { _DispatchDate = value; } }
    public virtual string DocketNo { get { return _DocketNo; } set { _DocketNo = value; } }
    public virtual string Remarks { get { return _Remarks; } set { _Remarks = value; } }
    public virtual int DispatchDayValidity { get { return _DispatchDayValidity; } set { _DispatchDayValidity = value; } }
    public virtual int DispatchDayID { get { return _DispatchDayID; } set { _DispatchDayID = value; } }
    public virtual string UserID { get { return _UserID; } set { _UserID = value; } }
    public virtual string CourierComp { get { return _CourierComp; } set { _CourierComp = value; } }
    public virtual string Ref1 { get { return _Ref1; } set { _Ref1 = value; } }
    public virtual string Ref2 { get { return _Ref2; } set { _Ref2 = value; } }
    public virtual string PatientID { get { return _PatientID; } set { _PatientID = value; } }
    public virtual string DispatchNo { get { return _DispatchNo; } set { _DispatchNo = value; } }
    public virtual string DispatchID { get { return _DispatchID; } set { _DispatchID = value; } }
    public virtual string panelInvoiceNo { get { return _panelInvoiceNo; } set { _panelInvoiceNo = value; } }
    public virtual decimal PanelAmt { get { return _PanelAmt; } set { _PanelAmt = value; } }
    public virtual string LedgerTransactionNO { get { return _LedgerTransactionNO; } set { _LedgerTransactionNO = value; } }
    public virtual DateTime BillDate { get { return _BillDate; } set { _BillDate = value; } }
    public virtual string BillNo { get { return _BillNo; } set { _BillNo = value; } }
    public virtual string editBy { get { return _editBy; } set { _editBy = value; } }
    public virtual DateTime editDate { get { return _editDate; } set { _editDate = value; } }
    public virtual decimal GrossAmount { get { return _GrossAmount; } set { _GrossAmount = value; } }
    public virtual decimal DiscAmt { get { return _DiscAmt; } set { _DiscAmt = value; } }
    public virtual string policyNo { get { return _policyNo; } set { _policyNo = value; } }
    public virtual string cardNo { get { return _cardNo; } set { _cardNo = value; } }
    public virtual int CentreID { get { return _CentreID; } set { _CentreID = value; } }
    public virtual string IpAddress { get { return _IpAddress; } set { _IpAddress = value; } }
    public virtual string CoverNoteNo { get { return _CoverNoteNo; } set { _CoverNoteNo = value; } }
    public virtual DateTime CoverNoteDate { get { return _CoverNoteDate; } set { _CoverNoteDate = value; } }
    public virtual decimal PanelPaidAmt { get { return _PanelPaidAmt; } set { _PanelPaidAmt = value; } }
    public virtual decimal PatientPaybleAmt { get { return _PatientPaybleAmt; } set { _PatientPaybleAmt = value; } }
    public virtual decimal PatientPaidAmt { get { return _PatientPaidAmt; } set { _PatientPaidAmt = value; } }
    public virtual decimal OutStanding { get { return _OutStanding; } set { _OutStanding = value; } }
    public virtual decimal OPDNetAmount { get { return _OPDNetAmount; } set { _OPDNetAmount = value; } }
    public virtual decimal IPDNetAmount { get { return _IPDNetAmount; } set { _IPDNetAmount = value; } }


    #endregion

    #region All Public Member Function
    public int Insert()
    {

        try
        {
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("Insert_Dispatch");
            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            MySqlParameter paramTnxID = new MySqlParameter();
            paramTnxID.ParameterName = "@ID";
            paramTnxID.MySqlDbType = MySqlDbType.Int32;
            paramTnxID.Size = 10;
            paramTnxID.Direction = ParameterDirection.Output;

            MySqlCommand cmd = new MySqlCommand(objSQL.ToString(), objTrans.Connection, objTrans);
            cmd.CommandType = CommandType.StoredProcedure;

            cmd.Parameters.Add(new MySqlParameter("@vType", Util.GetString(Type)));
            cmd.Parameters.Add(new MySqlParameter("@vTransactionID", Util.GetString(TransactionID)));
            cmd.Parameters.Add(new MySqlParameter("@vDateOfAdmission", Util.GetDateTime(DateOfAdmission)));
            cmd.Parameters.Add(new MySqlParameter("@vDateOfDischarge", Util.GetDateTime(DateOfDischarge)));
            cmd.Parameters.Add(new MySqlParameter("@vPName", Util.GetString(PName)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelID", Util.GetString(PanelID)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelName", Util.GetString(PanelName)));
            cmd.Parameters.Add(new MySqlParameter("@vBillAmount", Util.GetDecimal(BillAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vDispatchDate", Util.GetDateTime(DispatchDate)));
            cmd.Parameters.Add(new MySqlParameter("@vDocketNo", Util.GetString(DocketNo)));
            cmd.Parameters.Add(new MySqlParameter("@vRemarks", Util.GetString(Remarks)));
            cmd.Parameters.Add(new MySqlParameter("@vDispatchDayValidity", Util.GetString(DispatchDayValidity)));
            cmd.Parameters.Add(new MySqlParameter("@vDispatchDayID", Util.GetString(DispatchDayID)));
            cmd.Parameters.Add(new MySqlParameter("@vUserID", Util.GetString(UserID)));
            cmd.Parameters.Add(new MySqlParameter("@vCourierComp", Util.GetString(CourierComp)));
            cmd.Parameters.Add(new MySqlParameter("@vRef1", Util.GetString(Ref1)));
            cmd.Parameters.Add(new MySqlParameter("@vRef2", Util.GetString(Ref2)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientID", Util.GetString(PatientID)));
            cmd.Parameters.Add(new MySqlParameter("@vDispatchNo", Util.GetString(DispatchNo)));
            cmd.Parameters.Add(new MySqlParameter("@vpanelInvoiceNo", Util.GetString(panelInvoiceNo)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelAmt", Util.GetDecimal(PanelAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vLedgerTransactionNO", Util.GetString(LedgerTransactionNO)));
            cmd.Parameters.Add(new MySqlParameter("@vBillDate", Util.GetDateTime(BillDate)));
            cmd.Parameters.Add(new MySqlParameter("@vBillNo", Util.GetString(BillNo)));
            cmd.Parameters.Add(new MySqlParameter("@vGrossAmount", Util.GetDecimal(GrossAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vDiscAmt", Util.GetDecimal(DiscAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vpolicyNo", Util.GetString(policyNo)));
            cmd.Parameters.Add(new MySqlParameter("@vcardNo", Util.GetString(cardNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCentreID",Util.GetInt(CentreID)));
            cmd.Parameters.Add(new MySqlParameter("@vIpAddress", Util.GetString(IpAddress)));
            cmd.Parameters.Add(new MySqlParameter("@vCoverNoteNo", Util.GetString(CoverNoteNo)));
            cmd.Parameters.Add(new MySqlParameter("@vCoverNoteDate", Util.GetDateTime(CoverNoteDate)));
            cmd.Parameters.Add(new MySqlParameter("@vPanelPaidAmt", Util.GetDecimal(PanelPaidAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientPaybleAmt", Util.GetDecimal(PatientPaybleAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vPatientPaidAmt", Util.GetDecimal(PatientPaidAmt)));
            cmd.Parameters.Add(new MySqlParameter("@vOutStanding", Util.GetDecimal(OutStanding)));
            cmd.Parameters.Add(new MySqlParameter("@vOPDNetAmount", Util.GetDecimal(OPDNetAmount)));
            cmd.Parameters.Add(new MySqlParameter("@vIPDNetAmount", Util.GetDecimal(IPDNetAmount)));
            cmd.Parameters.Add(paramTnxID);
            ID = Util.GetInt(cmd.ExecuteScalar());
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





    #endregion

    public int Update()
    {
        try
        {
            int RowAffected;
            StringBuilder objSQL = new StringBuilder();
            objSQL.Append("UPDATE f_dispatch SET  TYPE = @Type,");
            objSQL.Append("DocketNo = @DocketNo,EditReason = @Remarks,Remarks= @Remarks, EditBy = @UserID, DispatchDate = @DispatchDate, CourierComp = @CourierComp, Ref1 = @Ref1, Ref2 = @Ref2,");
            objSQL.Append("PatientID =@PatientID,PanelAmount=@PanelAmt,LedgerTransactionNO=@LedgerTransactionNO,editDate=@editDate,CoverNoteNo=@CoverNoteNo,CoverNoteDate=@CoverNoteDate,PanelPaidAmt=@PanelPaidAmt,PatientPaybleAmt=@PatientPaybleAmt,PatientPaidAmt=@PatientPaidAmt,OutStanding=@OutStanding  ");
            objSQL.Append(" WHERE DispatchID=@DispatchID");

            if (IsLocalConn)
            {
                this.objCon.Open();
                this.objTrans = this.objCon.BeginTransaction();
            }
            this.Type = Util.GetString(Type);
            this.DocketNo = Util.GetString(DocketNo);         
            this.Remarks = Util.GetString(Remarks);
            this.editBy = Util.GetString(UserID);
            this.DispatchDate = Util.GetDateTime(DispatchDate);
            this.CourierComp = Util.GetString(CourierComp);
            this.Ref1 = Util.GetString(Ref1);
            this.Ref2 = Util.GetString(Ref2);
            this.editDate = DateTime.Now;
            this.PatientID = Util.GetString(PatientID);
            
            this.PanelAmt = Util.GetDecimal(PanelAmt);
            this.DispatchID = Util.GetString(DispatchID);
            this.LedgerTransactionNO = Util.GetString(LedgerTransactionNO);
            this.CoverNoteNo = Util.GetString(CoverNoteNo);
            this.CoverNoteDate = Util.GetDateTime(CoverNoteDate);
            this.PanelPaidAmt = Util.GetDecimal(PanelPaidAmt);
            this.PatientPaybleAmt = Util.GetDecimal(PatientPaybleAmt);
            this.PatientPaidAmt = Util.GetDecimal(PatientPaidAmt);
            this.OutStanding = Util.GetDecimal(OutStanding);
            this.LedgerTransactionNO = Util.GetString(LedgerTransactionNO);
            RowAffected = MySqlHelper.ExecuteNonQuery(objTrans, CommandType.Text, objSQL.ToString(),


                new MySqlParameter("@Type", Type),
                new MySqlParameter("@DocketNo", DocketNo),
                new MySqlParameter("@Remarks", Remarks),
                new MySqlParameter("@UserID", editBy),
                new MySqlParameter("@DispatchDate", DispatchDate),
                new MySqlParameter("@CourierComp", CourierComp),
                new MySqlParameter("@Ref1", Ref1),
                new MySqlParameter("@Ref2", Ref2),
                new MySqlParameter("@PatientID", PatientID),
               
                new MySqlParameter("@PanelAmt", PanelAmt),
                new MySqlParameter("@LedgerTransactionNO", Util.GetInt(LedgerTransactionNO)),
                new MySqlParameter("@editDate", editDate),
                new MySqlParameter("@DispatchID", DispatchID),
                new MySqlParameter("@CoverNoteNo", CoverNoteNo),
                new MySqlParameter("@CoverNoteDate", CoverNoteDate),
                new MySqlParameter("@PanelPaidAmt", PanelPaidAmt),
                new MySqlParameter("@PatientPaybleAmt", PatientPaybleAmt),
                new MySqlParameter("@PatientPaidAmt", PatientPaidAmt),
                new MySqlParameter("@OutStanding", OutStanding)
                );

            if (IsLocalConn)
            {
                this.objTrans.Commit();
                this.objCon.Close();
            }
            return RowAffected;

        }
        catch (Exception ex)
        {
            if (IsLocalConn)
            {
                if (objTrans != null) this.objTrans.Rollback();
                if (objCon.State == ConnectionState.Open) objCon.Close();
            }
            //Util.WriteLog(ex);
            throw (ex);
        }

    }
}