
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientIndent.aspx.cs" Inherits="Design_Store_PatientIndent" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title></title>
  
    <style type="text/css">
        .auto-style1 {
            width: 458px;
        }

        .auto-style2 {
            width: 15%;
        }
    </style>
    
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
 
      <script src="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.js"></script>
    <link href="../../Scripts/Date%20Time%20Js/jquery.timepicker.min.css" rel="stylesheet" />
       <script type="text/javascript">

           var onparmacyItem = function () {
               debugger;
               var pharmacyItem = $('#pharmacyItem');
               var grid = pharmacyItem.combogrid('grid');
               var selectedItems = grid.datagrid('getSelected');

               if (selectedItems != null)
                   if (selectedItems.ItemID.split('#')[9] == 'LSHHI5') {
                       $('.indentMedicalRequiredField').addClass('requiredField');
                       $('#txtRequestedQty').prop('disabled', true);
                   }
                   else {
                       $('.indentMedicalRequiredField').removeClass('requiredField');
                       $('#txtRequestedQty').prop('disabled', false);
                   }
               else {
                   $('.indentMedicalRequiredField').removeClass('requiredField');
                   $('#txtRequestedQty').prop('disabled', false);
               }


           }



           var calculateQuantity = function () {
               var dose = Number($('#txtDose').val());
               var times = Number($('#ddlTime').val());
               var duratation = Number($('#ddlDuration').val());

               var quantity = precise_round((dose * times * duratation), 2);
               $('#txtRequestedQty').val(quantity);
           }

       </script>

     <form id="form1" runat="server">
    
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Medicine Consumables Requisition</b>
                <br />
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" style="display:none"></asp:TextBox>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" style="display:none"   runat="server" clientidmode="Static"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnIPD_CaseTypeID"    runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnRoomID"   runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnCanIndentMedicalItems"   runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnCanIndentMedicalConsumables"   runat="server" clientidmode="Static" style="display:none"></span>
            </div>
             <div class="POuter_Box_Inventory" style="text-align: center;">

                <div class="row requistiontype" >
                    <div class="col-md-9"></div>
                    <div class="col-md-3">
                        <input type="radio" name="rblTypeofPrescription" id="rblIndent" value="0" onclick="RadioChange()" checked="checked" />
                        <label for="rblIndent" style="font-weight: bolder">Indent</label>
                    </div>
                    <div class="col-md-3">
                        <input type="radio" name="rblTypeofPrescription" id="rblOrder" value="1" onclick="RadioChange()" />
                        <label for="rblOrder" style="font-weight: bolder">Order</label>
                    </div>
                    <div class="col-md-9"></div>
                </div>

            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                Medicine Consumables Requisition
                </div>
          <table style="width:100%">
                <tr style="display:none"><td style="text-align:right;" class="auto-style2" >Type :&nbsp;</td><td><input type="radio" id="rdbitemwise" class="radioBtnClass" value="0" name="Type" checked="checked" />&nbsp;ItemWise
                    <input type="radio" id="rabGenericWise" class="radioBtnClass" value="1" name="Type"  />&nbsp;Generic Wise
                                                                               </td>
                    <td style="text-align:right">Requisition Type :&nbsp;</td><td><select id="ddlRequisitionType" style="width:225px"></select></td>
                </tr>
                <tr><td style="text-align:right;" class="auto-style2" >Department :&nbsp;</td><td>
                  <%--  <select id="ddlDepartment"  style="width:225px" class="ddlBtnClass" onchange="DepartmentValue()"></select>--%>
                    <asp:DropDownList ID="ddlDepartment" runat="server" ClientIDMode="Static" Width="225px"></asp:DropDownList>
                                                                                              </td>
                    <td style="text-align:right;display:none">Sub Group :&nbsp;</td><td style="display:none"><select id="ddlSubCategory" style="width:225px"></select></td>
                </tr></table>
                  <table style="width: 100%;border-collapse:collapse">
                <tr>
                                <td style="width:16%;text-align: right;">
                                    
                                    Medication Name</td>                         
                                <td style="width:360px;height:24px; text-align: left;font:bold">
               <input id="pharmacyItem"  tabindex="1" class="easyui-combogrid" style="width: 250px;" data-options="
			panelWidth: 600,
			idField: 'ItemID',
			textField: 'ItemName',
            mode:'remote',                                       
			url: 'PatientIndent.aspx?cmd=item',
            loadMsg: 'Serching... ',
			method: 'get',
            pagination:true,
            rownumbers:true,
            fit:true,
            border:false,   
            cache:false,  
            nowrap:true,                                                   
            emptyrecords: 'No records to display.',
            mode:'remote',
            onHidePanel:onparmacyItem ,
            onBeforeLoad: function (param) {
                   var Type = $('input[type=radio].radioBtnClass:checked').val();
                   var PanelID= $('#spnPanelID').text();
                   var DeptLegerNo=$('#ddlDepartment').val();
                   var SubcategoryID = $('#ddlSubCategory').val();
                   var canIndentMedicalItems=$('#spnCanIndentMedicalItems').text();
                   var canIndentMedicalConsumables=$('#spnCanIndentMedicalConsumables').text();
                   param.canIndentMedicalItems=canIndentMedicalItems;
                   param.canIndentMedicalConsumables=canIndentMedicalConsumables;
                   param.Type= Type;
                   param.PanelID = PanelID;
                   param.DeptLegerNo = DeptLegerNo;
                   param.SubcategoryID = SubcategoryID;},
			columns: [[
				{field:'ItemName',title:'ItemName',width:200,align:'left'},
                {field:'AvlQty',title:'Avl. Qty.',width:70,align:'center'}
			]],
			fitColumns: true
		">


                                </td>
                                 <td style="width:40%;display:none">
                                   <%--<asp:Button ID="btnMedicineSet" runat="server" TabIndex="100" ClientIDMode="Static" Text="Medicine Set" CssClass="ItDoseButton" />--%>
                                    <input type="button" class="hideprescription" value="Medicine Set" id="btnMedicineSet" style="display:none" onclick="onMedicineSetIndentsModelOpen()" />
                                     
                                </td>
                            </tr>
                 <tr>
                                    <td style="width:14%;text-align:right">Qty :&nbsp;</td>
                     <td> <input  type="text" id="txtRequestedQty" style="width:50px"  class="requiredField"  tabindex="9"  onlynumber="7" decimalplace="2" max-value="9999"  /> </td>
                                    <td style="text-align: left;display:none"  colspan="4">
                                        <table style="width:100%;border-collapse:collapse">
                                            <tr>
                                                <td style="text-align:left" class="auto-style5">
                                                      <input type="text" id="txtDose" style="width:80px" tabindex="6"  class="requiredField ItDoseTextinputNum indentMedicalRequiredField"   onlynumber="5" decimalplace="2" max-value="999" class="requiredField" onkeydown="calculateQuantity()" />  
                                        
                                        
                                                </td>                                                                       
                                                <td style="text-align:right;" class="auto-style6">
                                                    Times :</td>
                                                <td  style="text-align:left;width:6%">
                                                    <select id="ddlTime" style="width:80px" onchange="calculateQuantity();" tabindex="3" class="requiredField indentMedicalRequiredField"></select>
                                                </td>
                                                 <td style="text-align:right;" class="auto-style7">Duration :&nbsp;&nbsp;</td>
                                                 <td style="text-align: left;width:6%">
                                                     <select id="ddlDuration" onchange="calculateQuantity();" style="width:80px" tabindex="4" class="requiredField indentMedicalRequiredField" ></select> 
                                                     <span style="color: red; font-size: 10px;display:none">*</span>
                                                </td>
                                                   <td style="text-align:right;width:10%">Route :&nbsp;&nbsp;</td>
                                    <td style="text-align: left;width:6%">                                                                    
                                        <select id="ddlRoute" style="width:80px"  tabindex="5"></select><span style="color: red; font-size: 10px;display:none">*</span></td>
                                    <td style="text-align:right;width:10%">Meal :&nbsp;&nbsp;</td>
                                    <td style="text-align: left;width:6%">                                                                    
                                        <select id="ddlMeal" style="width:80px" tabindex="5">
                                            <option value="0">Select</option>
                                            <option value="After Meal">After Meal</option>
                                            <option value="Before Meal">Before Meal</option>
                                        </select>
                                        <span style="color: red; font-size: 10px;display:none">*</span>
                                    </td>
                                    <td style="text-align:right;width:10%">Quantity :</td>
                                    <td style="text-align:left;">
                                    
                                   
                                    </td>
                                            </tr>
                                        </table>  
                                        
                                        </td>                            
                                </tr>

   <tr class="showprescription">
                                    <td style="width:15%;text-align:right">Type Of Scheduler :&nbsp;</td>
                                    <td style="text-align: left"  colspan="4">
                                        <table style="width:100%;border-collapse:collapse">
                                            <tr>
                                                <td style="text-align: left;width:10%" class="auto-style5">
                                <select id="ddlTypeOfSchedular" onchange="$OnchangeTypeOfScheduler(function (response) { });" class="required">
                                    <option value="">Select</option>
                                    <option value="1">Run Once</option>
                                    <option value="0" selected="selected">Run At Intervals</option>
                                </select>
                                                </td>                                                                       
                                                <td style="width:10%;text-align:right" class="auto-style6">
                                                    Duration Unit :</td>
                                  <td  style="text-align: left;width:10%">
                               <select id="ddlTypeofDuration">
                                    <option value="">Select Type</option>
                                    <option value="HOUR">Hourly</option>
                                    <option value="MONTH">Monthly</option>
                                    <option value="WEEK">Weekly</option>
                                    <option value="DAY">Daily</option>
                                    <option value="MINUTE">Minutes</option>
                                </select>
                                   </td>

                                                 <td style="width:10%;text-align:right" class="auto-style7">Repeat Freq. :&nbsp;&nbsp;</td>
                                                 <td style="text-align: left;width:5%" >
                                                    
                                <input type="text" id="txtRepeatDuration" style="width:100%;float: left;"  class="form-control btn-sm"  onkeypress="return isNumber(event)" maxlength="2" autocomplete="off" />

                                                </td>
                                  <td style="width:15%;text-align:right" class="auto-style7">No. Of Repetition :&nbsp;&nbsp;</td>
                                                 <td style="text-align: left;width:5%" >
                                                    
                                <input type="text" id="txtNoOfRepetition" class="form-control btn-sm" style="width:100%;float: left;" onkeypress="return isNumber(event)"  maxlength="2" autocomplete="off" />
                                
                                                </td>
                                            </tr>
                                        </table>  
                                        
                                        </td>                            
                                </tr>

 <tr class="showprescription">
                                    <td style="width:15%;text-align:right">Start Date :&nbsp;</td>
                                    <td style="text-align: left"  colspan="4">
                                        <table style="width:100%;border-collapse:collapse">
                                            <tr>
                                                <td  style="text-align: left;width:10%" class="auto-style5">
                                                     <asp:TextBox ID="txtSelectDate" runat="server" ToolTip="Click to Select Date" TabIndex="5" ClientIDMode="Static" CssClass="ItDoseTextinputText required"></asp:TextBox>
                                <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtSelectDate" Format="dd-MMM-yyyy">
                                </cc1:CalendarExtender>
                                                </td>                                                                       
                                                <td style="text-align:right;width:10%" class="auto-style6">
                                                    Start Time :</td>
                                                <td style="text-align: left;width:10%">
                                                        <input type="text" id="txtStartTime" class="ItDoseTextinputText txtTime required"  />
                          
                                                      </td>
                                      <td style="text-align:left;width:5%"></td>                                    
                                      <td style="text-align:left;width:10%"></td> 
                                      <td style="text-align:left;width:10%"></td>                                    
                                      <td style="text-align:left;width:10%"></td> 

                                            </tr>
                                        </table>  
                                        
                                        </td>                            
                                </tr>




                <tr><td style="text-align:right">Remarks :&nbsp;</td><td class="auto-style1">  <input type="text" id="txtRemarks" class="ItDoseTextinputText" style="width:447px; height: 26px;" tabindex="7" onkeyup="AddInvestigation(this,event);" />&nbsp;</td>
                    <td style="text-align:right">&nbsp;</td><td></td>
                </tr>
                <tr><td style="text-align:right">Doctor :&nbsp;</td><td class="auto-style1"><select id="ddlDoctor" style="width:447px; height: 26px;" tabindex="8"></select></td>
                    <td style="text-align:left"><input type="button" id="btnAdd" title="Add Item" value="Add Item" class="ItDoseButton" tabindex="9" onclick="AddItem();"  /></td><td>&nbsp;</td>
                </tr>
                <tr>
                    <td style="text-align:right">Is Discharge Medicine :&nbsp;</td>
                    <td class="auto-style1">
                        <input type="checkbox"  id="chkIsDischargeMedicine" />
                    </td>
                </tr>


                </table>
             <div id="divOutput" style="max-height: 200px; overflow-y:auto;overflow-x: hidden;">
                            <table id="tbSelected"  rules="all" border="1" style="border-collapse: collapse; width: 100%;display:none" class="GridViewStyle">
                                <tr id="Header">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Code</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:left">Item Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center;display:none">Dose</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left;display:none">Time</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:left;display:none">Duration</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center;display:none">Route</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center;display:none">Meal</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:left">Quantity</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Remarks</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>
                                </tr>
                               
                            </table>



                               
                                                
<table id="tbOrderSelected"  rules="all" border="1" style="border-collapse: collapse; width: 100%;display:none" class="GridViewStyle">
                               <thead>
    
<tr>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">Item Name</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none"">ItemId</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center ;display:none">RemainderId</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none">Type Of Scheduler</th>
    <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;">Type Of Scheduler</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center">Duration Unit</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center; ">Start Date</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Start Time</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 240px; text-align:center;display:none ">Stop Date</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center;display:none">Stop Time</th>

<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Repeat Duration </th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center"> No Of Repetition </th>
<th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:center">Doctors</th>


 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Dose</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Time</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:left">Duration</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Route</th>
 <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Meal</th>
    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Quantity</th>

<th class="GridViewHeaderStyle" scope="col" style="width: 160px; text-align:center">Remarks</th>
<th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>
 </tr>   
</thead>
<tbody></tbody>                            
</table>





                            </div>
                 </div>
            <div style="text-align:center;display:none" class="POuter_Box_Inventory" id="divSave">
                <input type="button" value="Save" class="save margin-top-on-btn" id="btnSave" onclick="SaveIndent()"/>
                     <input type="checkbox" id="chkprint" checked="checked" />
                            Print
            </div>
        </div>
           
             


  <div id="divMedicineSetAndIndents" class="modal fade" >
    <div class="modal-dialog">
        <div class="modal-content" style="width: 900px">
            <div class="modal-header">
                <button type="button" class="close" onclick="onMedicineSetIndentsModelClose()"  aria-hidden="true">×</button>
                <h4 class="modal-title">Medicine Set And Indent Medicine</h4>
            </div>
            <div class="modal-body">
              <div class="row">
                  <div class="col-md-8"> 
                        <input type="radio" id="rdoset" value="Set" name="Select" checked="checked" onclick="chkMedicineType()"/>Prescribe Set
                        <input type="radio" id="rdoIndent" value="indent" name="Select"  onclick="chkMedicineType()"/>Indent Medicine 
                  </div>

                  <div class="col-md-8">
                        <select id="ddlMedicineset"  style="width:230px"  onchange="LoadMedSetItems()"></select>
                  </div>

                  
              </div>
                <div class="row">
                    <div id="PatientMedicineSearchOutput" style="height:250px;overflow:auto" ></div>
                </div>
            </div>
            <div class="modal-footer">
                 <span id="tempspnTimes" style="display:none"></span>
                 <span id="tempspnduration" style="display:none"></span>
                <input id="btnSaveSet" value="Add"  type="button" class="ItDoseButton" style="display:none" onclick="AddSetItem();"/>
                <input type="button" id="btnCancel" value="Cancel"  onclick="onMedicineSetIndentsModelClose()" />
            </div>
        </div>
    </div>
</div>




    </form>
    <script type="text/javascript">
        
        var onMedicineSetIndentsModelOpen = function () {
            $('#divMedicineSetAndIndents').showModel();
        }

        var onMedicineSetIndentsModelClose = function () {
            $('#divMedicineSetAndIndents').closeModel();
        }


        function chkMedicineType() {
            if ($("#rdoset").is(":checked")) {
                $('#ddlMedicineset').val(0).removeAttr('disabled');
                $('#PatientMedicineSearchOutput').html("");
                LoadMedicineSet();

            }
            else if ($("#rdoIndent").is(":checked")) {
                $('#ddlMedicineset').val(0).removeAttr('disabled');
                $('#PatientMedicineSearchOutput').html("");
                IndentMedicine();
            }

        }
        function IndentMedicine() {
            $('#ddlMedicineset option').remove();
            var TID = $('#spnTransactionID').text();
            $.ajax({
                url: "PatientIndent.aspx/LoadIndentMedicine",
                data: '{TnxID:"' + TID + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charst=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    $('#ddlMedicineset option').remove();
                    if (data != null) {
                        $("#ddlMedicineset").append($("<option></option>").val("0").html("Select"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlMedicineset').append($("<option></option>").val(data[i].id).html(data[i].dtEntry));
                        }
                    }
                }

            });
        }
        function LoadMedicineSet() {
            jQuery("#ddlMedicineset option").remove();
            $.ajax({
                url: "../Common/CommonService.asmx/LoadMedicineSet",
                data: '{DoctorID:""}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    if (data != null) {
                        $("#ddlMedicineset").append($("<option></option>").val("0").html("Select"));
                        for (var i = 0; i < data.length; i++) {
                            $('#ddlMedicineset').append($("<option></option>").val(data[i].ID).html(data[i].SetName));
                        }
                    }
                }
            });
        }
        function LoadMedSetItems() {
            if ($("#rdoset").is(":checked")) {
                $.ajax({
                    type: "POST",
                    data: '{SetID:"' + $('#ddlMedicineset').val() + '"}',
                    url: "../Common/CommonService.asmx/LoadMedSetItems",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        if (PatientData != null) {
                            var output = $('#tb_PatientMedicineSearch').parseTemplate(PatientData);
                            $('#PatientMedicineSearchOutput').html(output);
                            $('#PatientMedicineSearchOutput').show();
                            $('#btnSaveSet').show();
                            $("#Table1 tr").each(function () {
                                var id = $(this).attr("id");
                                var $rowid = $(this).closest("tr");
                                if (id != "Header") {
                                    var Sno = $rowid.find("#tdSno").text();
                                    var ddlSetTime = $rowid.find('#ddlSetTime' + Sno);
                                    var ddlSetDuration = $rowid.find('#ddlSetDuration' + Sno);
                                    var ddlRoute1 = $rowid.find('#ddlRoute1' + Sno);
                                    bindtime(ddlSetTime);
                                    bindDuration(ddlSetDuration);
                                    bindRoute(ddlRoute1);
                                    if ($(this).find('#spnTimes').html() != "") {
                                        $(this).find('#ddlSetTime' + Sno).val($(this).find('#spnTimes').html());
                                    }
                                    if ($(this).find('#spnduration').html() != "") {
                                        $(this).find('#ddlSetDuration' + Sno).val($(this).find('#spnduration').html());
                                    }
                                    if ($(this).find('#spnroute').html() != "") {
                                        $(this).find('#ddlRoute1' + Sno).val($(this).find('#spnroute').html());
                                    }
                                    if ($(this).find('#spnMeal').html() != "") {
                                        $(this).find('#ddlMeal' + Sno).val($(this).find('#spnMeal').html());
                                    }
                                }
                            });
                            //  BindDropdown();
                        }
                        else {
                            $('#PatientMedicineSearchOutput').html();
                            $('#PatientMedicineSearchOutput').hide();
                            $('#btnSaveSet').hide();
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#debugArea").html("");
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }

                });
            }
            else if ($("#rdoIndent").is(":checked")) {
                $.ajax({
                    url: "PatientIndent.aspx/LoadIndentItems",
                    data: '{IndentNo:"' + $('#ddlMedicineset').val() + '"}',
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    timeout: 120000,
                    async: false,
                    success: function (result) {
                        PatientData = jQuery.parseJSON(result.d);
                        if (PatientData != null) {
                            var output = $('#tb_PatientMedicineSearch').parseTemplate(PatientData);
                            $('#PatientMedicineSearchOutput').html(output);
                            $('#PatientMedicineSearchOutput').show();
                            $('#btnSaveSet').show();
                            $("#Table1 tr").each(function () {
                                var id = $(this).attr("id");
                                var $rowid = $(this).closest("tr");
                                if (id != "Header") {
                                    var Sno = $rowid.find("#tdSno").text();
                                    var ddlSetTime = $rowid.find('#ddlSetTime' + Sno);
                                    var ddlSetDuration = $rowid.find('#ddlSetDuration' + Sno);
                                    var ddlRoute = $rowid.find('#ddlRoute1' + Sno);
                                    bindtime(ddlSetTime)
                                    bindDuration(ddlSetDuration)
                                    bindRoute(ddlRoute);
                                }
                            });
                            // BindDropdown();
                        }
                        else {
                            $('#PatientMedicineSearchOutput').html();
                            $('#PatientMedicineSearchOutput').hide();
                            $('#btnSaveSet').hide();
                        }
                    },
                    error: function (xhr, status) {
                        window.status = status + "\r\n" + xhr.responseText;
                        $("#debugArea").html("");
                        $("#lblMsg").text('Error occurred, Please contact administrator');
                    }
                });
            }
        }
        function bindtime(ddlSetTime) {
            var Type = "Time";
            $.ajax({
                type: "POST",
                url: "../Common/CommonService.asmx/getTimeDuration",
                data: '{Type:"' + Type + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Tim = jQuery.parseJSON(result.d);
                    if (Tim != null) {
                        ddlSetTime.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Tim.length; i++) {
                            ddlSetTime.append($("<option></option>").val(Tim[i].Quantity + '#' + Tim[i].NAME).html(Tim[i].NAME));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function bindDuration(ddlSetDuration) {
            var Type = "Duration";
            $.ajax({
                type: "POST",
                url: "../Common/CommonService.asmx/getTimeDuration",
                data: '{Type:"' + Type + '"}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Dur = jQuery.parseJSON(result.d);
                    if (Dur != null) {
                        ddlSetDuration.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Dur.length; i++) {
                            ddlSetDuration.append($("<option></option>").val(Dur[i].Quantity + '#' + Dur[i].NAME).html(Dur[i].NAME));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function bindRoute(ddlRoute) {
            $.ajax({
                type: "POST",
                url: "PatientIndent.aspx/BindRoute",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    Route = jQuery.parseJSON(result.d);
                    if (Route != null) {
                        ddlRoute.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Route.length; i++) {
                            ddlRoute.append($("<option></option>").val(Route[i]).html(Route[i]));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
    </script>
     <script id="tb_PatientMedicineSearch" type="text/html">
  <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="Table1" style="width:100%; border-collapse:collapse;">
            <tr id="Tr1">
                <th class="GridViewHeaderStyle" scope="col">#</th>
                <th class="GridViewHeaderStyle" scope="col"></th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none" >itemID</th>
                <th class="GridViewHeaderStyle" scope="col">Medicine name</th>
                <th class="GridViewHeaderStyle" scope="col">Quantity</th>
                <th class="GridViewHeaderStyle" scope="col">Dose</th>
                <th class="GridViewHeaderStyle" scope="col">Time</th>
                <th class="GridViewHeaderStyle" scope="col">Duration</th>
                <th class="GridViewHeaderStyle" scope="col">Route</th>
                <th class="GridViewHeaderStyle" scope="col">Meal</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">UnitType</th>
                <th class="GridViewHeaderStyle" scope="col" style="display:none">Medicine Type</th>
                
            </tr>

            <#
       
            var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

            objRow = PatientData[j];
        
          #>
                    <tr id="<#=j+1#>" >
                        <td class="GridViewLabItemStyle" id="tdSno" ><#=j+1#></td>
                        <td class="GridViewLabItemStyle" ><input type="checkbox" id="chkSelect" checked="checked" /></td>
                        <td id="tdItemID" class="GridViewLabItemStyle" style="display:none;"><#=objRow.ItemID#></td>
                        <td  id="tdItemName" class="GridViewLabItemStyle" ><#=objRow.NAME#></td>
                        <td id="tdSetQuantity" class="GridViewLabItemStyle" style="text-align:center;"><input  type="text" class="ItDoseTextinputText" id="txtQtySet"  value="<#=objRow.quantity#>" style="width:70px" /></td>
                        <td id="tdDose" class="GridViewLabItemStyle" ><input  type="text" class="ItDoseTextinputText" id="txtsetDose" style="width:70px" value="<#=objRow.Dose#>" /></td>
                        <td id="tdTime" class="GridViewLabItemStyle" ><span id="spnTimes" style="display:none"><#=objRow.times#></span> <select id="ddlSetTime<#=j+1#>" style="width:120px" onchange="calculateLPopupQty();"> </select></td>
                        <td id="tdduration" class="GridViewLabItemStyle"><span id="spnduration" style="display:none"><#=objRow.Duration#></span>  <select id="ddlSetDuration<#=j+1#>"  clientidmode="Static" style="width:120px" onchange="calculateLPopupQty();"> </select>  </td>
                        <td id="tdroute1" class="GridViewLabItemStyle"> 
                            <span id="spnroute" style="display:none"><#=objRow.Route#></span>
                            <select id="ddlRoute1<#=j+1#>" ></select>
                        </td>
                        <td id="tdMeal" class="GridViewLabItemStyle"> 
                            <span id="spnMeal" style="display:none"><#=objRow.Meal#></span>
                            <select id="ddlMeal<#=j+1#>" clientidmode="Static" style="width:100px">
                                <option value="0">Select</option>
                                <option value="After Meal">After Meal</option>
                                <option value="Before Meal">Before Meal</option>
                            </select>
                        </td>
                        <td id="tdunittype" class="GridViewLabItemStyle" style="display:none;"><#=objRow.unittype#></td>   
                        <td id="tdMedicineType" class="GridViewLabItemStyle" style="display:none;"><#=objRow.MedicineType#></td>   
                </tr>
           <#}#>
     </table>    
    </script>
     <script id="sc_Deptstock" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tblDeptStock" style="border-collapse:collapse;">
            <tr>
                <th class="GridViewHeaderStyle" scope="col" style="width: 140px;">Dept. Name</th>
                <th class="GridViewHeaderStyle" scope="col" style="width: 20px">Quantity</th>
            </tr>
            <#
  var dataLength=DeptLedStock.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {
        objRow = DeptLedStock[j];
          #>
                    <tr id="Tr4" >
                     
                        <td class="GridViewLabItemStyle" style="display:none"><#=j+1#></td>
                        <td id="tdDeptName" class="GridViewLabItemStyle" style="width: 100px;"><#=objRow.DeptName#></td>
                        <td id="tdDeptQuantity" class="GridViewLabItemStyle" style="text-align:right"><#=objRow.Quantity#></td>
                </tr>
            <#}#>
     </table>    
    </script>
    <script type="text/javascript">
        function AddItem() {

            var value = $('input[name=rblTypeofPrescription]:checked').val();
            if (value == 0) {


                $("#btnAddInv").attr('disabled', 'disabled');
                $("#spnErrorMsg").text('');

                if ($("#pharmacyItem").combogrid('getValue') === null || $("#pharmacyItem").combogrid('getValue') === undefined) {
                    $("#btnAddInv").removeAttr('disabled');
                    $("#spnErrorMsg").text('Please Select Item');
                    $('#pharmacyItem').next().find('input').focus();
                    return;
                }
                $("#spnErrorMsg").text('');
                var ItemID = $("#pharmacyItem").combogrid('getValue').split('#')[0];
                var categoryID = $("#pharmacyItem").combogrid('getValue').split('#')[9];
                var conDup = 0;
                var AlreadyPreItem = 0;
                var prescribeItem = 0;
                var UserName = "";
                var Date = "";
                var RowColour = "";
                prescribeItem = alreadyPrescribeItem(ItemID);
                if (prescribeItem == 0) {
                    if (CheckDuplicateItem(ItemID)) {
                        $("#spnErrorMsg").text('Selected Item Already Added');
                        conDup = 1;
                        $("#btnAddInv").removeAttr('disabled');
                        $('#pharmacyItem').next().find('input').focus();
                        return;
                    }
                    if (conDup == "1") {
                        $("#spnErrorMsg").text('Selected Item Already Added');
                        $('#pharmacyItem').next().find('input').focus();
                        return;
                    }
                    var Time, Duration, Route, DurationValue, Meal;
                    var ItemName = $("#pharmacyItem").combogrid('getText');
                    var ItemCode = $("#pharmacyItem").combogrid('getValue').split('#')[8];
                    var SubCategoryID = $("#pharmacyItem").combogrid('getValue').split('#')[1];
                    var Dose = Number($('#txtDose').val());
                    if ($('#ddlTime').val() != "0")
                        Time = $('#ddlTime option:selected').text();
                    else
                        Time = "";
                    if ($('#ddlDuration').val() != "0") {
                        Duration = $('#ddlDuration option:selected').text();
                        DurationValue = $('#ddlDuration option:selected').val();
                    }
                    else {
                        Duration = "";
                        DurationValue = 0;
                    }
                    if ($('#ddlRoute').val() != "0")
                        Route = $('#ddlRoute option:selected').text();
                    else
                        Route = "";

                    if ($('#ddlMeal').val() != "0")
                        Meal = $('#ddlMeal option:selected').text();
                    else
                        Meal = "";



                    if (categoryID == 'LSHHI5') {

                        if (Dose <= 0) {
                            modelAlert('Please Enter Dose.', function () {
                                $('#txtDose').focus();
                            });
                            return false;
                        }

                        if (Time == '') {
                            modelAlert('Please Select Times.', function () {
                                $('#ddlTime').focus();
                            });
                            return false;
                        }

                        if (Duration == '') {
                            modelAlert('Please Select Duration.', function () {
                                $('#ddlDuration').focus();
                            });
                            return false;
                        }
                    }


                    var Quantity = Number($('#txtRequestedQty').val());
                    if (Quantity <= 0) {
                        modelAlert("Please Enter Valid Quantity", function () {
                            $('#txtRequestedQty').focus();
                        });

                        return false;
                    }
                    var Remarks = $('#txtRemarks').val();
                    var unitType = $("#pharmacyItem").combogrid('getValue').split('#')[3].trim();
                    $('#tbSelected').css('display', 'block');
                    $('#tbSelected').append('<tr ' + RowColour + '><td class="GridViewLabItemStyle" style="width:70px" ><span id="ItemCode">' + ItemCode +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px"><span id="spnItemName">' + ItemName +
                                            '</span><span id="spnSubCategoryID"  style="display:none" > ' + SubCategoryID + ' </span><span id="spnitemID" style="display:none" >' + ItemID +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none " ><span id="spnDose">' + Dose +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnTime">' + Time +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnDuration">' + Duration +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnDurationValue">' + DurationValue +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnRoute">' + Route +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="spnMeal">' + Meal +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnQuantity">' + Quantity +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnRemarks">' + Remarks +
                                            '</span><span id="spnunitType" style="display:none">' + unitType + '</span></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td>');
                    $("#btnAddInv").removeAttr('disabled');
                    $('#divOutput,#tbSelected').show();
                    $('#txtRemarks').val('');
                    $('#txtRequestedQty').val('');
                    $('#txtDose').val('');
                    $('#ddlTime').val('0');
                    $('#ddlDuration').val('0');
                    $('#ddlRoute').val('0');
                    $('#ddlMeal').val('0');
                    $('#divSave').show();
                    $("#spnErrorMsg").text('');
                    $('#pharmacyItem').combogrid('reset');
                    $("#pharmacyItem").combogrid('clear');
                    $('#pharmacyItem').next().find('input').focus();
                    $('.textbox-text').focus();
                }

            } else {

                if ($("#pharmacyItem").combogrid('getValue') == "") {
                    modelAlert('Please Select Item')
                    return false;
                }
                $("#btnAddInv").attr('disabled', 'disabled');
                $("#spnErrorMsg").text('');
                if ($("#pharmacyItem").combogrid('getValue') === null || $("#pharmacyItem").combogrid('getValue') === undefined) {
                    modelAlert('Please Select Item', function () {
                        $("#btnAddInv").removeAttr('disabled');
                        return false;
                    });
                }

                var ItemID = $("#pharmacyItem").combogrid('getValue').split('#')[0];
                var categoryID = $("#pharmacyItem").combogrid('getValue').split('#')[9];
                var conDup = 0;
                var UserName = "";
                var Date = "";
                var RowColour = "";

                alreadyPrescribeOrderItem({ PatientID: $.trim($('#spnPatientID').text()), ItemID: ItemID }, function (response) {
                    if (response) {
                        if (CheckOrderDuplicateItem(ItemID)) {
                            modelAlert('Selected Item Already Added');
                            conDup = 1;
                            $("#btnAddInv").removeAttr('disabled');
                            $('#pharmacyItem').combogrid('reset');
                            $("#pharmacyItem").combogrid('clear');
                            $('#pharmacyItem').next().find('input').focus();
                            return;
                        }
                        if (conDup == "1") {
                            modelAlert('Selected Item Already Added');
                            return;
                        }

                        var Time, Duration, Route, DurationValue, Meal;
                        var ItemName = $("#pharmacyItem").combogrid('getText');
                        var ItemCode = $("#pharmacyItem").combogrid('getValue').split('#')[8];
                        var SubCategoryID = $("#pharmacyItem").combogrid('getValue').split('#')[1];
                        var Dose = Number($('#txtDose').val());
                        if ($('#ddlTime').val() != "0")
                            Time = $('#ddlTime option:selected').text();
                        else
                            Time = "";
                        if ($('#ddlDuration').val() != "0") {
                            Duration = $('#ddlDuration option:selected').text();
                            DurationValue = $('#ddlDuration option:selected').val();
                        }
                        else {
                            Duration = "";
                            DurationValue = 0;
                        }
                        if ($('#ddlRoute').val() != "0")
                            Route = $('#ddlRoute option:selected').text();
                        else
                            Route = "";

                        if ($('#ddlMeal').val() != "0")
                            Meal = $('#ddlMeal option:selected').text();
                        else
                            Meal = "";



                        if (categoryID == 'LSHHI5') {

                            if (Dose <= 0) {
                                modelAlert('Please Enter Dose.', function () {
                                    $('#txtDose').focus();
                                });
                                return false;
                            }

                            if (Time == '') {
                                modelAlert('Please Select Times.', function () {
                                    $('#ddlTime').focus();
                                });
                                return false;
                            }

                            if (Duration == '') {
                                modelAlert('Please Select Duration.', function () {
                                    $('#ddlDuration').focus();
                                });
                                return false;
                            }
                        }


                        var Quantity = Number($('#txtRequestedQty').val());
                        if (Quantity <= 0) {
                            modelAlert("Please Enter Valid Quantity", function () {
                                $('#txtRequestedQty').focus();
                            });

                            return false;
                        }



                        var TID = $("#spnTransactionID").text();


                        var SelectedDate = $('#txtSelectDate').val();
                        var StartTime = $('#txtStartTime').val();
                        txtRemainderName = "";//$("#ddlRemainderType option:selected").text();
                        ddlRemainderType = "";// $("#ddlRemainderType").val();
                        ddlTypeOfSchedular = $("#ddlTypeOfSchedular").val();

                        ddlTypeOfSchedularText = $("#ddlTypeOfSchedular option:selected").text();


                        ddlTypeofDuration = $("#ddlTypeofDuration").val();
                        txtSelectDate = $("#txtSelectDate").val();
                        txtStartTime = $("#txtStartTime").val();
                        txtStopDate = txtSelectDate;
                        txtStopTime = txtStartTime;


                        txtRemarks = $("#txtRemarks").val();
                        txtRepeatDuration = $("#txtRepeatDuration").val();
                        ddlDoctor = $("#ddlDoctor").val();
                        ddlDoctorName = $("#ddlDoctor option:selected").text();

                        var NoOfRepetitiontodo = $("#txtNoOfRepetition").val();

                        //if (ddlRemainderType == "") {
                        //    modelAlert("Please Select Remainder type");
                        //    return false;
                        //}

                        if (txtStartTime == "") {
                            modelAlert("Please Select Start Time");
                            return false;
                        }

                        if (ddlTypeOfSchedular == 0) {
                            if (ddlTypeofDuration == "") {
                                modelAlert("Please Select Type of Duration");
                                return false;
                            }
                            if (txtRepeatDuration == "") {
                                modelAlert("Please Enter repeat Duration");
                                return false;
                            }


                            if (txtNoOfRepetition = "") {
                                modelAlert("Please Enter Valid No Of Repetition.");
                                return false;
                            }
                        } 

                        $('#tbOrderSelected').css('display', 'block');

                      
                            $('#tbOrderSelected tbody').append('<tr><td class="GridViewLabItemStyle" style="width:120px;"><span id="tdItemName">' + ItemName + '</span> </td>' +
                                                    '<td class="GridViewLabItemStyle" style="text-align:center; display:none"><span id="tditemID" >' + ItemID + '</span></td>' +
                                                    '<td class="GridViewLabItemStyle" style="width:120px;display:none"> <span id="tdtxtRemainderName" style="">' + txtRemainderName + '</span> </td>' +
                                                    '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdddlRemainderType">' + ddlRemainderType + '</span> </td>' +
                                                    '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdddlTypeOfSchedular" >' + ddlTypeOfSchedular + '</span> </td>' +
                                                      '<td class="GridViewLabItemStyle" style="width:120px; "> <span id="tdddlTypeOfSchedularText" >' + ddlTypeOfSchedularText + '</span> </td>' +



                                               '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdddlTypeofDuration" style="">' + ddlTypeofDuration + '</span> </td>' +
                                                '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtSelectDate" style="">' + txtSelectDate + '</span> </td>' +
                                                '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtStartTime" style="">' + txtStartTime + '</span> </td>' +

                                                 '<td class="GridViewLabItemStyle" style="width:120px;display:none"> <span id="tdtxtStopDate" style="">' + txtStopDate + '</span> </td>' +
                                                '<td class="GridViewLabItemStyle" style="width:120px;display:none"> <span id="tdtxtStopTime" style="">' + txtStopTime + '</span> </td>' +


                                                '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtRepeatDuration" style="">' + txtRepeatDuration + '</span> </td>' +
                                                 '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtNoOfRepetition" style="">' + NoOfRepetitiontodo + '</span> </td>' +


                                               '<td class="GridViewLabItemStyle" style="width:120px; display:none"> <span id="tdddlDoctor" >' + ddlDoctor + '</span> </td>' +
                                                '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdddlDoctorName" style="">' + ddlDoctorName + '</span> </td>' +




                                                    '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnDose">' + Dose +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnTime">' + Time +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnDuration">' + Duration +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;display:none" ><span id="tdspnDurationValue">' + DurationValue +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnRoute">' + Route +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="tdspnMeal">' + Meal +
                                            '</span></td><td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdspnQuantity">' + Quantity + '</span> </td>' +
                            '<td class="GridViewLabItemStyle" style="width:120px;"> <span id="tdtxtRemarks" style="">' + txtRemarks + '</span> </td>' +




                        '<td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');




                        $("#btnAddInv").removeAttr('disabled');
                        $('#tbSelected').hide();
                        $('#LabOutput,#tbOrderSelected').show();
                        $('#txtRemarks').val('');
                        $('#txtRequestedQty').val('');
                        $('#txtDose').val('');
                        $('#ddlTime').val('0');
                        $('#ddlDuration').val('0');
                        $('#ddlRoute').val('0');
                        $('#ddlMeal').val('0');
                        $('#divSave').show();
                        $("#spnErrorMsg").text('');
                        $('#pharmacyItem').combogrid('reset');
                        $("#pharmacyItem").combogrid('clear');
                        $('#pharmacyItem').next().find('input').focus();
                        $('.textbox-text').focus();


                    }
                });
            }


        }
        function CheckDuplicateItem(ItemID) {
            var count = 0;
            $('#tbSelected tr:not(#Header)').each(function () {
                var item = $(this).find('#spnitemID').text().trim();
                if ($(this).find('#spnitemID').text().trim() == ItemID) {
                    count = count + 1;
                }
            });
            if (count == 0)
                return false;
            else
                return true;
        }
        function RemoveRows(rowid) {
            $(rowid).closest('tr').remove();
            if ($('#tbSelected tr:not(#Header)').length == 0) {
                $('#tbSelected').hide();
                $('#divSave').hide();
            }
            $("#spnErrorMsg").text('');
        }
        function alreadyPrescribeItem(ItemID) {
            if ($.trim($('#spnPatientID').text()) != "") {
                var prescribeItem = 0;
                $.ajax({
                    url: "../IPD/Services/IPDLabPrescription.asmx/getAlreadyPrescribeItem",
                    data: '{PatientID:"' + $.trim($('#spnPatientID').text()) + '",ItemID:"' + ItemID + '"}',
                    type: "POST",
                    async: false,
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    success: function (mydata) {
                        var prescribeData = jQuery.parseJSON(mydata.d);
                        if (prescribeData != null && prescribeData != "") {
                            if (confirm('This Medicine is Already Prescribed By ' + prescribeData[0].UserName + ' Date On ' + prescribeData[0].EntryDate + '. Do You Want To Prescribe Again ???')) {
                                prescribeItem = 0;
                            }
                            else {
                                prescribeItem = 1;
                            }
                        }
                        else
                            prescribeItem = 0;

                    }
                });
            }
            return prescribeItem;
        }
        function validatedot() {
            if (($("#txtRequestedQty").val().charAt(0) == ".")) {
                $("#txtRequestedQty").val('');
                return false;
            }

            return true;
        }
        function checkForSecondDecimal(sender, e) {
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;


            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));


                if ((charCode == 46) || (charCode == 110) || (charCode == 190)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 13) {
                    e.preventDefault();
                    //        AddItem();
                }
            }

            return true;
        }
        var bindAdmissionDoctor = function (callback) {
            var $ddlDoctor = $('#ddlDoctor');
            serverCall('../IPD/Services/IPDAdmission.asmx/bindAdmissionDoctor', { defaultvalue: {} }, function (response) {
                $ddlDoctor.bindDropDown({ data: JSON.parse(response), valueField: 'DoctorID', textField: 'Name', isSearchAble: true });
                callback($ddlDoctor.val());
            });
        }
        function AddSetItem() {

            if ($("#ddlMedicineset").val() != "0") {
                jQuery("#Table1 tr").each(function (i) {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "Tr1") {
                        if ($(this).find("#chkSelect").is(":checked")) {
                            var ItemID = jQuery.trim($rowid.find("#tdItemID").text());
                            var conDup = 0;
                            var AlreadyPreItem = 0;
                            var prescribeItem = 0;
                            var UserName = "";
                            var Date = "";
                            var RowColour = "";
                            prescribeItem = alreadyPrescribeItem(ItemID);
                            if (prescribeItem == 0) {
                                if (CheckDuplicateItem(ItemID)) {
                                    $("#spnErrorMsg").text('Selected Item Already Added');
                                    conDup = 1;
                                    $("#btnAddInv").removeAttr('disabled');
                                    //$('#txtSearch').focus();
                                    return;
                                }
                                if (conDup == "1") {
                                    $("#spnErrorMsg").text('Selected Item Already Added');
                                    //$('#txtSearch').focus();
                                    return;
                                }
                                var Sno = jQuery.trim($rowid.find("#tdSno").text());
                                var ItemName = jQuery.trim($rowid.find("#tdItemName").text());
                                var Quantity = jQuery.trim($rowid.find("#txtQtySet").val());
                                if (Quantity == '0' || Quantity == 'undefined' || Quantity == '')
                                    Quantity = "";
                                var Dose = jQuery.trim($rowid.find("#txtsetDose").val());
                                if (Dose == "" || Dose == 'undefined')
                                    Dose = "";
                                var Time = jQuery.trim($rowid.find('#ddlSetTime' + Sno).val());
                                if (Time == '0' || Time == undefined || Time == '')
                                    Time = "";
                                var Duration = jQuery.trim($rowid.find('#ddlSetDuration' + Sno).val());
                                if (Duration == undefined || Duration == '0' || Duration == '')
                                    Duration = "";
                                var Route = jQuery.trim($rowid.find('#ddlRoute1' + Sno).val());
                                if (Route == '0' || Route == 'undefined' || Route == '')
                                    Route = "";
                                var Meal = jQuery.trim($rowid.find('#ddlMeal' + Sno).val());
                                if (Meal == '0' || Meal == 'undefined' || Meal == '')
                                    Meal = "";
                                $('#tbSelected').css('display', 'block');
                                var ItemCode = "", Remarks = "", SubCategoryID = "";
                                var unitType = jQuery.trim($rowid.find('#tdunittype').text());
                                $('#tbSelected').append('<tr ' + RowColour + '><td class="GridViewLabItemStyle"  ><span id="ItemCode">' + ItemCode +
                                                        '</span></td><td class="GridViewLabItemStyle" ><span id="spnItemName">' + ItemName +
                                                        '</span><span id="spnSubCategoryID"  style="display:none" > ' + SubCategoryID + ' </span><span id="spnitemID" style="display:none" >' + ItemID +
                                                        '</span></td><td class="GridViewLabItemStyle" style="display:none" ><span id="spnDose">' + Dose +
                                                        '</span></td><td class="GridViewLabItemStyle"style="display:none"  ><span id="spnTime">' + Time +
                                                        '</span></td><td class="GridViewLabItemStyle" style="display:none" ><span id="spnDuration">' + Duration +
                                                        '</span></td><td class="GridViewLabItemStyle" style="display:none" ><span id="spnRoute">' + Route +
                                                        '</span></td><td class="GridViewLabItemStyle"  style="display:none"><span id="spnMeal">' + Meal +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnQuantity">' + Quantity +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnRemarks">' + Remarks +
                                                        '</span><span id="spnunitType" style="display:none">' + unitType + '</span></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td>');
                            }
                        }
                    }
                });
                $('#divSave').show();
                onMedicineSetIndentsModelClose();
            }
        }
        var PrintIndent = function (indentno, callback) {

            var transactionId = $("#spnTransactionID").text();
            serverCall('PatientIndent.aspx/printIndent', { IndentNo: indentno, TransactionId: transactionId }, function (response) {
                var $responseData = JSON.parse(response);
                if ($responseData.Output != "" && $responseData.Output != null) {
                    window.open($responseData.Output);
                }

                callback(true);
            });

        }
        function SaveIndent() {

            var value = $('input[name=rblTypeofPrescription]:checked').val();
            var IsPrint = ($('#chkprint').prop('checked') ? 1 : 0);

            if (value == 0) {


            if ($("#ddlDepartment").val() != "0") {
                $('#btnSave').text('Saving...').attr('disabled', 'disabled');
                var IndentType = "";
                if ($("#ddlRequisitionType").val() != '0')
                    IndentType = $('#ddlRequisitionType').val();
                var data = new Array();
                var Obj = new Object();
                jQuery("#tbSelected tr").each(function (i) {
                    var id = jQuery(this).attr("id");
                    var $rowid = jQuery(this).closest("tr");
                    if (id != "Header") {
                        Obj.ItemID = jQuery.trim($rowid.find("#spnitemID").text());
                        Obj.MedicineName = jQuery.trim($rowid.find("#spnItemName").text());
                        Obj.Quantity = jQuery.trim($rowid.find("#spnQuantity").text());
                        Obj.Dose = jQuery.trim($rowid.find("#spnDose").text());
                        Obj.Time = jQuery.trim($rowid.find('#spnTime').text());
                        Obj.Duration = jQuery.trim($rowid.find('#spnDuration').text());
                        Obj.DurationValue = Number($rowid.find('#spnDurationValue').text());
                        Obj.Route = jQuery.trim($rowid.find("#spnRoute").text());
                        Obj.Meal = jQuery.trim($rowid.find("#spnMeal").text());
                        Obj.TID = $('#spnTransactionID').text();
                        Obj.PID = $('#spnPatientID').text();
                        Obj.UnitType = jQuery.trim($rowid.find("#spnunitType").text());
                        Obj.Dept = $("#ddlDepartment").val();
                        Obj.IndentType = IndentType;
                        Obj.DoctorID = $('#ddlDoctor').val();
                        Obj.IPDCaseTypeID = $("#spnIPD_CaseTypeID").text();
                        Obj.Room_ID = $("#spnRoomID").text();
                        data.push(Obj);
                        Obj = new Object();
                    }
                });

                var isDischargeMedicine = ($('#chkIsDischargeMedicine').prop('checked') ? 1 : 0);

                if (data.length > 0) {
                    $.ajax({
                        url: "PatientIndent.aspx/SaveIndent",
                        data: JSON.stringify({ Data: data, isDischargeMedicine: isDischargeMedicine }),
                        type: "POST",
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        async: true,
                        dataType: "json",
                        success: function (result) {
                            Data = result.d;
                            if (Data.split('#')[0] == "1") {
                                modelAlert('Record Saved Successfully', function () {
                                    if (IsPrint == 1)
                                    PrintIndent(Data.split('#')[1], function () {});

                                    ClearControls();
                                });
                            }
                            else {
                                $('#btnSave').text('Save').removeAttr('disabled');
                            }
                        },
                        error: function (xhr, status) {
                            modelAlert(status + "\r\n" + xhr.responseText);
                            $('#btnSave').text('Save').removeAttr('disabled');
                            window.status = status + "\r\n" + xhr.responseText;
                        }
                    });
                }
            }
            else
                modelAlert('Please Select Department');


            } else {
                SaveOrderEntry(function () { });
            }



        }
        function ClearControls() {
            $("#tbSelected tr:not(#Header)").remove();
            $('#tbSelected').removeAttr('disabled').hide();
            $('#divSave').hide();
            $('#btnSave').removeAttr('disabled');
            bindAdmissionDoctor(function () {

            });
        }
        function AddInvestigation(sender, e) {
            var key = (e.keyCode ? e.keyCode : e.charCode);
            // alert(key);
            if (e.which == "")
                e.preventDefault();
            if ((e.which == 13)) {
                e.preventDefault();
                AddItem();
            }
            validatedot();
        }
        function EnterQuantity(sender, e) {
            var key = (e.keyCode ? e.keyCode : e.charCode);
            // alert(key);
            if (e.which == "")
                e.preventDefault();
            if ((e.which == 13)) {
                e.preventDefault();
                $('#txtRequestedQty').focus();
            }

        }
    </script>


    <link rel="stylesheet" type="text/css" href="../../Styles/easyui.css"> 
    <script type="text/javascript" src="../../Scripts/jquery.easyui.min.js"></script>   
  
    <script type="text/javascript">
        $(function () {
            $('.textbox-text').bind("keyup", function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                if (code == 13) {
                    $('#txtRequestedQty').focus();
                }
                if (code == 9) {
                    $('#pharmacyItem').next().find('table').find('tr').find('td').find('input').focus();
                }
            });
            $('#txtRequestedQty').bind("keyup", function (e) {
                var code = (e.keyCode ? e.keyCode : e.which);
                //alert(code);
                if (code == 13) {
                    $('.textbox-text').focus();
                    AddItem();
                }
                if (code == 9) {
                    $('.textbox-text').focus();
                    AddItem();
                }
            });
            $('#pharmacyItem').next().find('input').focus();
            $('#txtRequestedQty').removeAttr('tabIndex').attr('tabIndex', '2');
            //$('#ddlMedicineset').chosen();
            BindRequisitionType();
            BindSubcategory();
            BindDurationForm();
            BindTimeForm();
            BindRouteForm();
            //bindAdmissionDoctor();
            LoadMedicineSet();
            bindAdmissionDoctor(function () {
                BindPatientDetail();
            });
        });
        function QuantityCal() {
            var Time = $('#ddlTime').val();
            var Duration = $('#ddlDuration').val();

            var MedicineType = $("#pharmacyItem").combogrid('getValue').split('#')[7].trim();
            var Quantity = 0;
            //alert(MedicineType);
            if (MedicineType == "tablet" || MedicineType == "capsule") {
                Quantity = Time * Duration;
                if (Quantity != 0)
                    $('#txtRequestedQty').val(Quantity);
                else
                    $('#txtRequestedQty').val('1');
            }
            else if (MedicineType == "Syrup" || MedicineType == "EyeDrop" || MedicineType == "EarDrop" || MedicineType == "NosalDrop" || MedicineType == "Tube"
                || MedicineType == "Lotion" || MedicineType == "Cream" || MedicineType == "Injection" || MedicineType == "Inhaler"
                ) {
                $('#txtRequestedQty').val('1');
            }
            else {
                $('#txtRequestedQty').val('');
            }
        }

        var BindTimeForm = function () {

            serverCall('../Common/CommonService.asmx/getTimeDuration', { Type: 'Time' }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlTime').bindDropDown({
                    data: responseData,
                    valueField: 'Quantity',
                    textField: 'NAME',
                    defaultValue: 'Select',
                });
            });
        }


        //function BindTimeForm() {
        //    var Type = "Time";
        //    $.ajax({
        //        type: "POST",
        //        url: "../Common/CommonService.asmx/getTimeDuration",
        //        data: '{Type:"' + Type + '"}',
        //        contentType: "application/json; charset=utf-8",
        //        dataType: "json",
        //        async: false,
        //        success: function (result) {
        //            var Tim = jQuery.parseJSON(result.d);
        //            if (Tim != null) {
        //                $('#ddlTime').append($("<option></option>").val("0").html("Select"));
        //                for (i = 0; i < Tim.length; i++) {
        //                    $('#ddlTime').append($("<option></option>").val(Tim[i].Quantity + '#' + Tim[i].NAME).html(Tim[i].NAME));
        //                }
        //            }
        //        },
        //        error: function (xhr, ajaxOptions, thrownError) {
        //            jQuery("#lblMsg").text('Error occurred, Please contact administrator');
        //        }

        //    });
        //}


        var BindDurationForm = function () {
            serverCall('../Common/CommonService.asmx/getTimeDuration', { Type: 'Duration' }, function (response) {
                var responseData = JSON.parse(response);
                $('#ddlDuration').bindDropDown({
                    data: responseData,
                    valueField: 'Quantity',
                    textField: 'NAME',
                    defaultValue: 'Select',
                });
            });
        }
        //function BindDurationForm() {
        //    var Type = "Duration";
        //    $.ajax({
        //        type: "POST",
        //        url: "../Common/CommonService.asmx/getTimeDuration",
        //        data: '{Type:"' + Type + '"}',
        //        contentType: "application/json; charset=utf-8",
        //        dataType: "json",
        //        async: false,
        //        success: function (result) {
        //            var Dur = jQuery.parseJSON(result.d);
        //            if (Dur != null) {
        //                $('#ddlDuration').append($("<option></option>").val("0").html("Select"));
        //                for (i = 0; i < Dur.length; i++) {
        //                    $('#ddlDuration').append($("<option></option>").val(Dur[i].Quantity + '#' + Dur[i].NAME).html(Dur[i].NAME));
        //                }
        //            }
        //        },
        //        error: function (xhr, ajaxOptions, thrownError) {
        //            jQuery("#lblMsg").text('Error occurred, Please contact administrator');
        //        }

        //    });
        //}
        function BindRouteForm() {
            $.ajax({
                type: "POST",
                url: "PatientIndent.aspx/BindRoute",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Rou = jQuery.parseJSON(result.d);
                    if (Rou != null) {
                        $('#ddlRoute').append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Rou.length; i++) {
                            $('#ddlRoute').append($("<option></option>").val(Rou[i]).html(Rou[i]));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function BindRequisitionType() {
            var ddlRequisitionType = $('#ddlRequisitionType');
            $('#ddlRequisitionType option').remove();
            $.ajax({
                type: "POST",
                url: "PatientIndent.aspx/BindRequisitionType",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Dur = jQuery.parseJSON(result.d);
                    if (Dur != null) {
                        ddlRequisitionType.append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Dur.length; i++) {
                            ddlRequisitionType.append($("<option></option>").val(Dur[i].TypeID).html(Dur[i].TypeName));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function BindSubcategory() {
            $('#ddlSubCategory option').remove();
            $.ajax({
                type: "POST",
                url: "PatientIndent.aspx/BindSubcategory",
                data: '{}',
                contentType: "application/json; charset=utf-8",
                dataType: "json",
                async: false,
                success: function (result) {
                    var Dur = jQuery.parseJSON(result.d);
                    if (Dur != null) {
                        $('#ddlSubCategory').append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Dur.length; i++) {
                            $('#ddlSubCategory').append($("<option></option>").val(Dur[i].SubCategoryID).html(Dur[i].Name));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }


        $(document).ready(function () {
            var roleid = '<%=Session["RoleID"].ToString()%>';
            if (roleid == '52') {
                hideandshowfield(1);
                var value = $('#rblOrder').attr('checked', 'checked');
                hideandshowfield(value);
            }
            else {
                var value = $('#rblIndent').attr('checked', 'checked');
                hideandshowfield(value); hideandshowfield(0);
            }
            $('.requistiontype').hide()
      
            $OnchangeTypeOfScheduler(function (response) { });
            $('.txtTime').timepicker({
                timeFormat: 'h:mm p',
                interval: 1,
                minTime: '00:01',
                maxTime: '11:59pm',
                // defaultTime: '00:01',
                startTime: '00:01',
                dynamic: false,
                dropdown: true,
                scrollbar: true
            });


            $('.textbox-prompt').attr('tabindex', 1);
        });
        function BindPatientDetail() {
            jQuery.ajax({
                url: "../IPD/Services/IPDLabPrescription.asmx/BindPatientDetails",
                data: '{TID:"' + $('#spnTransactionID').text() + '",PID:"' + $('#spnPatientID').text() + '"}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    var data = jQuery.parseJSON(result.d);
                    if (data != "") {
                       // alert(data[0].DoctorID);
                        $('#ddlDoctor').val(data[0].DoctorID).chosen('destroy').chosen();
                    }
                },
                error: function (xhr, status) {
                }
            });
        }





        //################## Order  Section ################
        function RadioChange() {
            var value = $('input[name=rblTypeofPrescription]:checked').val();
            hideandshowfield(value);
        }

        function hideandshowfield(SelVal) {
            if (SelVal == 0) {
                $(".hideprescription").show();
                $(".showprescription").hide();

            } else {
                $(".hideprescription").hide();
                $(".showprescription").show();
            }
        }


        var $OnchangeTypeOfScheduler = function () {
            if ($('#ddlTypeOfSchedular').val() == "1") {
                $("#txtSelectDate").attr("disabled", false);
                $("#txtStartTime").attr("disabled", false);

                $("#txtRepeatDuration").attr("disabled", true);
                $("#ddlTypeofDuration").attr("disabled", true);
                $("#txtNoOfRepetition").attr("disabled", true);



                $("#txtNoOfRepetition").removeClass("required");
                $("#txtRepeatDuration").removeClass("required");
                $("#ddlTypeofDuration").removeClass("required");


            }
            else if ($('#ddlTypeOfSchedular').val() == "0") {
                $("#txtSelectDate").attr("disabled", false);
                $("#txtStartTime").attr("disabled", false);
                $("#txtRepeatDuration").attr("disabled", false);
                $("#ddlTypeofDuration").attr("disabled", false);
                $("#txtNoOfRepetition").attr("disabled", false);

                $("#txtNoOfRepetition").addClass("required");
                $("#txtRepeatDuration").addClass("required");
                $("#ddlTypeofDuration").addClass("required");



            }
            else {

                $("#txtSelectDate").attr("disabled", true);
                $("#txtStartTime").attr("disabled", true);
                $("#txtRepeatDuration").attr("disabled", true);
                $("#ddlTypeofDuration").attr("disabled", true);
                $("#txtNoOfRepetition").attr("disabled", true);


            }

        }


        function isNumber(evt) {
            evt = (evt) ? evt : window.event;
            var charCode = (evt.which) ? evt.which : evt.keyCode;
            if (charCode > 31 && (charCode < 48 || charCode > 57)) {
                return false;
            }
            return true;
        }




        function GetOrderDetails() {
            var dataLTD = new Array();
            var objLTD = new Object();
            $("#tbOrderSelected tbody tr").each(function () {

                var $rowid = $(this).closest("tr");

                objLTD.ItemID = $.trim($rowid.find("#tditemID").text());
                objLTD.Quantity = $.trim($rowid.find("#tdspnQuantity").text());
                objLTD.ItemName = $.trim($rowid.find("#tdItemName").text());
                objLTD.TransactionID = $('#spnTransactionID').text();
                objLTD.PatientId = $('#spnPatientID').text();

                objLTD.DoctorID = $.trim($rowid.find("#tdddlDoctor").text());

                objLTD.RemainderName = $.trim($rowid.find("#tdtxtRemainderName").text());
                objLTD.RemainderType = $.trim($rowid.find("#tdddlRemainderType").text());
                objLTD.StartDate = $.trim($rowid.find("#tdtxtSelectDate").text());
                objLTD.StartTime = $.trim($rowid.find("#tdtxtStartTime").text());
                objLTD.RepeatDuration = $.trim($rowid.find("#tdtxtRepeatDuration").text());

                objLTD.TypeofDuration = $.trim($rowid.find("#tdddlTypeofDuration").text());
                objLTD.TypeOfSchedular = $.trim($rowid.find("#tdddlTypeOfSchedular").text());
                objLTD.Remark = $.trim($rowid.find("#tdtxtRemarks").text());
                objLTD.StopDate = $.trim($rowid.find("#tdtxtStopDate").text());
                objLTD.StopTime = $.trim($rowid.find("#tdtxtStopTime").text());

                objLTD.Dose = $.trim($rowid.find("#tdspnDose").text());
                objLTD.Time = $.trim($rowid.find("#tdspnTime").text());
                objLTD.Duration = $.trim($rowid.find("#tdspnDuration").text());
                objLTD.DurationVal = $.trim($rowid.find("#tdspnDurationValue").text());
                objLTD.Route = $.trim($rowid.find("#tdspnRoute").text());
                objLTD.Meal = $.trim($rowid.find("#tdspnMeal").text());
                objLTD.isDischargeMedicine = ($('#chkIsDischargeMedicine').prop('checked') ? 1 : 0);
                objLTD.TypeOfMedicine = $('input[name=Type]:checked').val();
                objLTD.ToDepartment = $("#ddlDepartment").val();
                objLTD.RequisitionType = $('#ddlRequisitionType').val();
                objLTD.NoOFRepetition = $.trim($rowid.find("#tdtxtNoOfRepetition").text());

                dataLTD.push(objLTD);
                objLTD = new Object();


            });
            return dataLTD;
        }





        var SaveOrderEntry = function () {
            var resultLTD = GetOrderDetails();

            $('#btnSave').attr('disabled', true).val("Submitting...");



            $.ajax({
                url: "../IPD/Services/IPDLabPrescription.asmx/SaveMedicienOrder",
                data: JSON.stringify({ LTD: resultLTD }),
                type: "Post",
                contentType: "application/json; charset=utf-8",
                timeout: "120000",
                async: false,
                dataType: "json",
                success: function (result) {

                    var responseData = JSON.parse(result.d);
                    var btnSave = $('#btnSave');

                    modelAlert(responseData.response, function () {

                        if (responseData.status)
                            window.location.reload();
                        else
                            $(btnSave).removeAttr('disabled').val('Save');

                    });



                }
            });

        }




        var alreadyPrescribeOrderItem = function (data, callBack) {
            if (data.PatientID.trim() != '') {
                serverCall('../IPD/Services/IPDLabPrescription.asmx/getAlreadyPrescribeOrderItem', data, function (response) {
                    responseData = JSON.parse(response);
                    if (responseData != null && responseData != "") {
                        modelConfirmation('Do You Want To Prescribe Again  ?', 'This Investigation is Already Prescribed  </br> On Date  ' + responseData[0].EntryDate, 'Prescribe Again', 'Cancel', function (response) {
                            if (response)
                                callBack(response);
                        });
                    }
                    else
                        callBack(true);
                });
            }
            else
                callBack(true);
        }

        function CheckOrderDuplicateItem(ItemID) {
            var count = 0;
            $('#tbOrderSelected tbody tr').each(function () {
                var item = $(this).find('#tditemID').text().trim();
                if ($(this).find('#tditemID').text().trim() == ItemID) {
                    count = count + 1;
                }
            });
            if (count == 0)
                return false;
            else
                return true;
        }

        //################## Order  Section  End ################
    </script>

</body>
</html>
