using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

/// <summary>
/// Summary description for DoctorShareFixedAmt
/// </summary>
public class DoctorShareFixedAmt
{
 
    //'ID',
   #region All Memory Variable
    public string _CategoryID;
    public string _SubCategoryID;
    public string _DoctorID;
    public string _IsActive;
    public string _CreatedBy;
    public DateTime _CreatedDate;
    public string _DeactivatedBy;
    public DateTime _DeactivateDate;
    public string _ItemID;

    public Decimal _OPDPercent;
    public Decimal _OPDFixedAmt;
    public Decimal _OPDBonusPercent;
    public Decimal _OPDBonusFixedAmt;
    public Decimal _IPDPercent;
    public Decimal _IPDFixedAmt;
    public Decimal _IPDBonusPercent;
    public Decimal _IPDBonusFixedAmt;
    public Decimal _HospSharePer;
    public Decimal _HospShareAmt;
    public Decimal _HospSharePerIPD;
    public Decimal _HospShareAmtIPD;
    public int _Panel_Type;

    public string _PatientType;
    public Decimal _IsPatientTypeApply;
    public int _IsPackage;
    public string _PackageType;
    public Decimal _BonusPer;
    public string _PackageId;
    public string _PanelID;
    public string _PanelGroup_Id;
    public int _IsSurgery;
    public int _Patient_SourceId;
   #endregion
    #region set all variable
    public int IsSurgery
    {
        get { return _IsSurgery; }
        set { _IsSurgery = value; }
    }
    public string CategoryID
    {
        get { return _CategoryID; }
        set { _CategoryID = value; }
    }
    public string SubCategoryID {

        get { return _SubCategoryID; }
        set { _SubCategoryID = value; }
    }
    public string DoctorID
    {
        get { return _DoctorID; }
        set { _DoctorID = value; }
    }
    public string IsActive
    {
        get { return _IsActive; }
        set { _IsActive = value; }
    }
    public string CreatedBy
    {
        get { return _CreatedBy; }
        set { _CreatedBy = value; }
    }
    public DateTime CreatedDate
    {
        get { return _CreatedDate; }
        set { _CreatedDate = value; }
    }
    public string DeactivatedBy
    {
        get { return _DeactivatedBy; }
        set { _DeactivatedBy = value; }
    }
    public DateTime DeactivateDate
    {
        get { return _DeactivateDate; }
        set { _DeactivateDate = value; }
    }
    public string ItemID
    {
        get { return _ItemID; }
        set { _ItemID = value; }
    }

    public Decimal OPDPercent
    {
        get { return _OPDPercent; }
        set { _OPDPercent = value; }
    }
    public Decimal OPDFixedAmt
    {
        get { return _OPDFixedAmt; }
        set { _OPDFixedAmt = value; }
    }
    public Decimal OPDBonusPercent
    {
        get { return _OPDBonusPercent; }
        set { _OPDBonusPercent = value; }
    }
    public Decimal OPDBonusFixedAmt
    {
        get { return _OPDBonusFixedAmt; }
        set { _OPDBonusFixedAmt = value; }
    }

    public Decimal IPDPercent
    {
        get { return _IPDPercent; }
        set { _IPDPercent = value; }
    }
    public Decimal IPDFixedAmt
    {
        get { return _IPDFixedAmt; }
        set { _IPDFixedAmt = value; }
    }
    public Decimal IPDBonusPercent
    {
        get { return _IPDBonusPercent; }
        set { _IPDBonusPercent = value; }
    }
    public Decimal IPDBonusFixedAmt
    {
        get { return _IPDBonusFixedAmt; }
        set { _IPDBonusFixedAmt = value; }
    }

    public Decimal HospSharePer
    {
        get { return _HospSharePer; }
        set { _HospSharePer = value; }
    }
    public Decimal HospShareAmt
    {
        get { return _HospShareAmt; }
        set { _HospShareAmt = value; }
    }
    public Decimal HospSharePerIPD
    {
        get { return _HospSharePerIPD; }
        set { _HospSharePerIPD = value; }
    }
    public Decimal HospShareAmtIPD
    {
        get { return _HospShareAmtIPD; }
        set { _HospShareAmtIPD = value; }
    }

    public string PatientType
    {
        get { return _PatientType; }
        set { _PatientType = value; }
    }
    public Decimal IsPatientTypeApply
    {
        get { return _IsPatientTypeApply; }
        set { _IsPatientTypeApply = value; }
    }
    public int IsPackage
    {
        get { return _IsPackage; }
        set { _IsPackage = value; }
    }
    public string PackageType
    {
        get { return _PackageType; }
        set { _PackageType = value; }
    }  
    public Decimal BonusPer
    {
        get { return _BonusPer; }
        set { _BonusPer = value; }
    }
    public string PackageId
    {
        get { return _PackageId; }
        set { _PackageId = value; }
    }
    public string PanelID {
        get { return _PanelID; }
        set {   _PanelID=value; }
    }
    public string PanelGroup_Id
    {
        get { return _PanelGroup_Id; }
        set { _PanelGroup_Id=value; }
    }
    public int Panel_Type
    {
        get { return _Panel_Type; }
        set { _Panel_Type = value; }
    }

    public int Patient_SourceId//
    {
        get { return _Patient_SourceId; }
        set { _Patient_SourceId = value; }
    }
    

    #endregion
    public DoctorShareFixedAmt()
	{
		//
		// TODO: Add constructor logic here
		//
	}
}
public class ExcludeData {
    public string CategoryID { get; set; }
    public string DoctorID { get; set; }
    public string PackageId { get; set; }
}