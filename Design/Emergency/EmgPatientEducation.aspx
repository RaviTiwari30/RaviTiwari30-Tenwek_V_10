<%@ Page Language="C#" AutoEventWireup="true" CodeFile="EmgPatientEducation.aspx.cs" Inherits="Design_Emergency_EmgPatientEducation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Patient and Family Education</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Patient Education Assessment</div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Patient and family's benifits and value
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlPtBenifits">
                            <option value="0">Select</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Ability to Read
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="rdoability" value="1" />No
                         <input type="radio" name="rdoability" value="0" checked="checked"/>Not Applicable
                         <input type="radio" name="rdoability" value="2" />Yes
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Education Level
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlEduLevel">
                            <option value="0">Select</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Language
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlLanguage">
                            <option value="0">Select</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Emotional barriers and motivations
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlbarrier">
                            <option value="0">Select</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Physical and Cognitive Limitations
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <select id="ddlPhysical">
                            <option value="0">Select</option>
                            <option value="1">1</option>
                            <option value="2">2</option>
                        </select>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Patient's willingness to recieve information
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-12">
                        <input type="radio" name="rdowillingness" value="1" />Agreeable/Show Interest
                         <input type="radio" name="rdowillingness" value="0" checked="checked" />No Interest
                         <input type="radio" name="rdowillingness" value="2" />Refused
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">Education Given On</div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Education given to 
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="checkbox" id="chkNextToKin" value="Next to Kin" /><label id="lblNext">Next to Kin</label>
                         <input type="checkbox" id="chkParent" value="Parent" /><label id="lblParent">Parent</label>
                         <input type="checkbox" id="chkPatient" value="Pateint" /><label id="lblPatient">Patient</label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Safe Use of Medicine
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="rdoMedicine" value="1" />No
                         <input type="radio" name="rdoMedicine" value="0" checked="checked" />Not Applicable
                         <input type="radio" name="rdoMedicine" value="2" />Yes
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Safe Use of Medical equipments
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="rdoEquipments" value="1" />No
                         <input type="radio" name="rdoEquipments" value="0" checked="checked" />Not Applicable
                         <input type="radio" name="rdoEquipments" value="2" />Yes
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Potential interaction between medications and food
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="rdoPotential" value="1" />No
                         <input type="radio" name="rdoPotential" value="0" checked="checked" />Not Applicable
                         <input type="radio" name="rdoPotential" value="2" />Yes
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Nutritional Guidance
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="rdoNutritional" value="1" />No
                         <input type="radio" name="rdoNutritional" value="0" checked="checked" />Not Applicable
                         <input type="radio" name="rdoNutritional" value="2" />Yes
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Pain Management
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="rdoPain" value="1" />No
                         <input type="radio" name="rdoPain" value="0" checked="checked" />Not Applicable
                         <input type="radio" name="rdoPain" value="2" />Yes
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Rehabitilation Techniques
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="radio" name="rdoRehabilitation" value="1" />No
                         <input type="radio" name="rdoRehabilitation" value="0" checked="checked"/>Not Applicable
                         <input type="radio" name="rdoRehabilitation" value="2" />Yes
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-8">
                        <label class="pull-left">
                            Any Other Information given
                        </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-6">
                        <input type="text" id="txtotherInformation" />
                    </div>
                </div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-10">
                    </div>
                    <div class="col-md-4">
                        <input type="button" id="btnSave" class="ItdoseButton" value="Save" onclick="SaveRecord();" />
                        <input type="button" id="btnUpdate" class="ItdoseButton" value="Update" style="display:none;" onclick="UpdateRecord();" />
                    </div>
                </div>
                <div class="col-md-10">
                      <label id="lblID" style="display:none"></label>
                        <label id="lblCreateDate" style="display:none"></label>
                </div>
            </div>
            </div>
    </form>
</body>
</html>

<script type="text/javascript">
    $(document).ready(function () {
        SearchEduData();
    });

    function SearchEduData() {
        var TransID = '<%=Request.QueryString["TID"]%>';
        serverCall('EmgPatientEducation.aspx/SearchEducationData', { TID: TransID }, function (response) {
            StockData = jQuery.parseJSON(response);
            if (StockData.length != 0) {
                $('#ddlPtBenifits').val(StockData[0].PatientBenifits);
                $('input[name="rdoability"]').filter("[value='" + StockData[0].Ability + "']").attr('checked', true);
                $('#ddlEduLevel').val(StockData[0].EducationLevel);
                $('input[name="rdowillingness"]').filter("[value='" + StockData[0].Willingness + "']").attr('checked', true);
                $('#ddlLanguage').val(StockData[0].Language);
                $('#ddlbarrier').val(StockData[0].Barrier);
                $('#ddlPhysical').val(StockData[0].Physical);
                if (StockData[0].Edu_NexttoKin != "")
                    $('#chkNextToKin').attr('checked', 'checked');
                if (StockData[0].Edu_Parent != "")
                    $('#chkParent').attr('checked', 'checked');
                if (StockData[0].Edu_Patient != "")
                    $('#chkPatient').attr('checked', 'checked');
                $('input[name="rdoMedicine"]').filter("[value='" + StockData[0].SafeUSeofMedicine + "']").attr('checked', true);
                $('input[name="rdoEquipments"]').filter("[value='" + StockData[0].SafeUSeofEquip + "']").attr('checked', true);
                $('input[name="rdoPotential"]').filter("[value='" + StockData[0].Potential + "']").attr('checked', true);
                $('input[name="rdoNutritional"]').filter("[value='" + StockData[0].Nutrition + "']").attr('checked', true);
                $('input[name="rdoPain"]').filter("[value='" + StockData[0].Pain + "']").attr('checked', true);
                $('input[name="rdoRehabilitation"]').filter("[value='" + StockData[0].Rehabilitation + "']").attr('checked', true);
                $('#txtotherInformation').val(StockData[0].OtherInformation);
                $('#lblID').text(StockData[0].ID);
                $('#lblCreateDate').text(StockData[0].CreateDate)
                $('#btnSave').hide();
                $('#btnUpdate').show();
            }
        });
    }



    function SaveRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TID"]%>';
        var PID = '<%=Request.QueryString["PID"]%>';
        var EMGNo = '<%=Request.QueryString["EMGNo"]%>';
        serverCall('EmgPatientEducation.aspx/SaveEducationRecord', { Data: resultData, TID: TID, PID: PID, EMGNo: EMGNo }, function (response) {
            var result = parseInt(response);
            if (result == 1) {
                modelAlert('Record Save Successfully', function (reponse) {
                    SearchEduData();
                });
            }
            else
                modelAlert('Error Occured');
        });
    }

    function UpdateRecord() {
        var resultData = getData();
        var TID = '<%=Request.QueryString["TID"]%>';
        var PID = '<%=Request.QueryString["PID"]%>';
        var EMGNo = '<%=Request.QueryString["EMGNo"]%>';
        serverCall('EmgPatientEducation.aspx/UpdateEducationRecord', { Data: resultData, TID: TID, PID: PID, EMGNo: EMGNo }, function (response) {
            var result = parseInt(response);
            if (result == 1) {
                modelAlert('Record Update Successfully', function (response) {
                    SearchEduData();
                });
            }
            else
                modelAlert('Error Occured');
        });
    }

    function getData() {
        var dataEducation = new Array();
        var ObjEducation = new Object();  
      
        ObjEducation.ID = $("#lblID").text();
        ObjEducation.CreatedDate = $('#lblCreateDate').text();
        ObjEducation.PatientBenifits = $('#ddlPtBenifits option:selected').val();
        ObjEducation.Ability = $('input:radio[name=rdoability]:checked').val()
        ObjEducation.EducationLevel = $('#ddlEduLevel option:selected').val();
        ObjEducation.Language = $('#ddlLanguage option:selected').val();
        ObjEducation.Barrier = $('#ddlbarrier option:selected').val();
        ObjEducation.Physical = $('#ddlPhysical option:selected').val();
        ObjEducation.Willingness = $('input:radio[name=rdowillingness]:checked').val();
        if ($('#chkNextToKin').is(':checked'))
            ObjEducation.Edu_NexttoKin = $('#chkNextToKin').val();
        if ($('#chkParent').is(':checked'))
            ObjEducation.Edu_Parent = $('#chkParent').val();
        if ($('#chkPatient').is(':checked'))
            ObjEducation.Edu_Patient = $('#chkPatient').val();

        ObjEducation.SafeUSeofMedicine = $('input:radio[name=rdoMedicine]:checked').val();
        ObjEducation.SafeUSeofEquip = $('input:radio[name=rdoEquipments]:checked').val();
        ObjEducation.Potential = $('input:radio[name=rdoPotential]:checked').val();
        ObjEducation.Nutrition = $('input:radio[name=rdoNutritional]:checked').val();
        ObjEducation.Pain = $('input:radio[name=rdoPain]:checked').val();
        ObjEducation.Rehabilitation = $('input:radio[name=rdoRehabilitation]:checked').val();
        ObjEducation.OtherInformation = $('#txtotherInformation').val();

        dataEducation.push(ObjEducation);
        return dataEducation;
    }
</script>
