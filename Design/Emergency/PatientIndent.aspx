
<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientIndent.aspx.cs" Inherits="Design_Emergency_PatientIndent" %>
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
     <form id="form1" runat="server">
    
        <div id="Pbody_box_inventory">
            <ajax:ScriptManager ID="sc" runat="server"></ajax:ScriptManager>
            <div class="POuter_Box_Inventory" style="text-align: center;">

                <b>Medicine Requisition</b>
                <br />
                <asp:TextBox ID="txtHash" CssClass="txtHash" runat="server" ClientIDMode="Static" style="display:none"></asp:TextBox>
                <span id="spnErrorMsg" class="ItDoseLblError"></span>
                <span id="spnPanelID" style="display:none"   runat="server" clientidmode="Static"></span>
                <span id="spnTransactionID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnPatientID" runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnIPD_CaseTypeID"    runat="server" clientidmode="Static" style="display:none"></span>
                <span id="spnRoomID"   runat="server" clientidmode="Static" style="display:none"></span>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader" style="text-align: left;">
                Patient Order Set
                </div>
          <table style="width:100%">
                <tr><td style="text-align:right;" class="auto-style2" >Type :&nbsp;</td><td><input type="radio" id="rdbitemwise" class="radioBtnClass" value="0" name="Type" checked="checked" />&nbsp;ItemWise
                    <input type="radio" id="rabGenericWise" class="radioBtnClass" value="1" name="Type"  />&nbsp;Generic Wise
                                                                               </td>
                    <td style="text-align:right">Requisition Type :&nbsp;</td><td><select id="ddlRequisitionType" style="width:225px"></select></td>
                </tr>
                <tr><td style="text-align:right;" class="auto-style2" >Department :&nbsp;</td><td>
                  <%--  <select id="ddlDepartment"  style="width:225px" class="ddlBtnClass" onchange="DepartmentValue()"></select>--%>
                    <asp:DropDownList ID="ddlDepartment"  CssClass="required" runat="server" ClientIDMode="Static" Width="225px"></asp:DropDownList>
                                                                                              </td>
                    <td style="text-align:right">Sub Group :&nbsp;</td><td><select id="ddlSubCategory" style="width:225px"></select></td>
                </tr></table>
                  <table style="width: 100%;border-collapse:collapse">
                <tr>
                                <td style="width:16%;text-align: right;">
                                    
                                    By&nbsp;First&nbsp;Name&nbsp;:&nbsp;</td>                         
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
            onHidePanel: function(){ },
            onBeforeLoad: function (param) {
                   var Type = $('input[type=radio].radioBtnClass:checked').val();
                   var PanelID= $('#spnPanelID').text();
                   var DeptLegerNo=$('#ddlDepartment').val();
                   var SubcategoryID = $('#ddlSubCategory').val();
                   param.Type= Type;
                   param.PanelID = PanelID;
                   param.DeptLegerNo = DeptLegerNo;
                   param.SubcategoryID = SubcategoryID;
				   param.requestType='search';
				   },
			columns: [[
				{field:'ItemName',title:'ItemName',width:200,align:'left'},
                {field:'HSNCode',title:'HSNCode',width:100,align:'center'},
        		{field:'AvlQty',title:'Avl. Qty.',width:70,align:'center'}
			]],
			fitColumns: true
		">


                                </td>
                                 <td style="width:40%">
                                   <%--<asp:Button ID="btnMedicineSet" runat="server" TabIndex="100" ClientIDMode="Static" Text="Medicine Set" CssClass="ItDoseButton" />--%>
                                    <input type="button" value="Medicine Set" id="btnMedicineSet" onclick="onMedicineSetIndentsModelOpen()" />
                                     <button type="button" onclick="openPrescriptionMedicines(this)">Prescription Medicine</button>
                                </td>
                            </tr>
                 <tr>
                                    <td style="width:14%;text-align:right">Quantity :&nbsp;</td>
                                    <td style="text-align: left"  colspan="4">
                                        <table style="width:100%;border-collapse:collapse">
                                            <tr>
                                                <td style="text-align:left" class="auto-style5">
                                                      <input type="text" id="txtRequestedQty" style="width:50px"  class="requiredField"
                                                          onkeypress="return checkForSecondDecimal(this,event);" tabindex="9"  /> 
                                        
                                        
                                                </td>                                                                       
                                                <td style="text-align:right;" class="auto-style6">
                                                    Times :</td>
                                                <td  style="text-align:left;width:6%">
                                                    <select id="ddlTime" style="width:100px" onchange="QuantityCal();" tabindex="3"></select>
                                                </td>
                                                 <td style="text-align:right;" class="auto-style7">Duration :&nbsp;&nbsp;</td>
                                                 <td style="text-align: left;width:6%">
                                                     <select id="ddlDuration" onchange="QuantityCal();" style="width:100px" tabindex="4" ></select> 
                                                     <span style="color: red; font-size: 10px;display:none">*</span>
                                                </td>
                                                   <td style="text-align:right;width:10%">Route :&nbsp;&nbsp;</td>
                                    <td style="text-align: left;width:6%">                                                                    
                                        <select id="ddlRoute" style="width:100px"  tabindex="5"></select><span style="color: red; font-size: 10px;display:none">*</span></td>
                                    <td style="text-align:right;width:10%">Dose :</td>
                                    <td style="text-align:left;">
                                    <input type="text" id="txtDose" style="width:80px" tabindex="6" />  </td>
                                            </tr>
                                        </table>  
                                        
                                        </td>                            
                                </tr>
                <tr><td style="text-align:right">Remaks :&nbsp;</td><td class="auto-style1">  <input type="text" id="txtRemarks" class="ItDoseTextinputText" style="width:422px; height: 26px;" tabindex="7" onkeyup="AddInvestigation(this,event);" />&nbsp;</td>
                    <td style="text-align:right">&nbsp;</td><td></td>
                </tr>
                <tr><td style="text-align:right">Doctor :&nbsp;</td><td class="auto-style1"><select id="ddlDoctor" style="width:225px" tabindex="8" class="requiredField"></select></td>
                    <td style="text-align:left"><input type="button" id="btnAdd" title="Add Item" value="Add Item" class="ItDoseButton" tabindex="9" onclick="AddItem();"  /></td><td>&nbsp;</td>
                </tr>
<%--                <tr>
                    <td style="text-align:right">Is Discharge Medicine :&nbsp;</td>
                    <td class="auto-style1">
                        <input type="checkbox"  id="chkIsDischargeMedicine" />
                    </td>
                </tr>--%>


                </table>
             <div id="divOutput" style="max-height: 200px; overflow-y:auto;overflow-x: hidden;">
                            <table id="tbSelected"  rules="all" border="1" style="border-collapse: collapse; width: 100%;display:none" class="GridViewStyle">
                                <tr id="Header">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Code</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="text-align:left">Item Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Dose</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:left">Time</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 150px; text-align:left">Duration</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Route</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:left">Doctor Name</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:left">Quantity</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 100px; text-align:center">Remarks</th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 30px; text-align:center">Remove</th>
                                </tr>
                               
                            </table>
                            </div>
                 </div>
            <div style="text-align:center;display:none" class="POuter_Box_Inventory" id="divSave">
                <input type="button" value="Save" class="save margin-top-on-btn" id="btnSave" onclick="SaveIndent()"/>
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
                var Time, Duration, Route;
                var ItemName = $("#pharmacyItem").combogrid('getText');
                var ItemCode = $("#pharmacyItem").combogrid('getValue').split('#')[8];
                var SubCategoryID = $("#pharmacyItem").combogrid('getValue').split('#')[1];
                var Dose = $('#txtDose').val();
                if ($('#ddlTime').val() != "0")
                    Time = $('#ddlTime').val();
                else
                    Time = "";
                if ($('#ddlDuration').val() != "0")
                    Duration = $('#ddlDuration').val();
                else
                    Duration = "";
                if ($('#ddlRoute').val() != "0")
                    Route = $('#ddlRoute option:selected').text();
                else
                    Route = "";
                var Quantity = $('#txtRequestedQty').val();
                if (Quantity == "" || Quantity == "0") {
                    modelAlert("Please Enter Valid Quantity");
                    $('#txtRequestedQty').focus();
                    return false;
                }
                var Remarks = $('#txtRemarks').val();
                var unitType = $("#pharmacyItem").combogrid('getValue').split('#')[3].trim();
               
                var departmentID=$('#ddlDepartment').val();
                if (departmentID == '0') {
                    modelAlert('Please Select Department First.');
                    return;
                }


                var doctorID = $('#ddlDoctor').val();
                var doctorName=$('#ddlDoctor option:selected').text();
                if (doctorID == '0') {
                    modelAlert('Please Select doctor');
                    return;
                }


                var data = {
                    RowColour: RowColour,
                    ItemCode: ItemCode,
                    ItemName: ItemName,
                    SubCategoryID: SubCategoryID,
                    ItemID: ItemID,
                    Dose: Dose,
                    Time: Time,
                    Duration: Duration,
                    Route: Route,
                    Quantity: Quantity,
                    Remarks: Remarks,
                    unitType: unitType,
                    PatientMedicine_ID: 0,
                    departmentID: departmentID,
                    DoctorID: doctorID,
                    DoctorName: doctorName
                }

                medicinePreviewRow(data);



                $("#btnAddInv").removeAttr('disabled');
                $('#divOutput,#tbSelected').show();
                $('#txtRemarks').val('');
                $('#txtRequestedQty').val('');
                $('#txtDose').val('');
                $('#ddlTime').val('0');
                $('#ddlDuration').val('0');
                $('#ddlRoute').val('0');
                $('#divSave').show();
                $("#spnErrorMsg").text('');
                $('#pharmacyItem').combogrid('reset');
                $("#pharmacyItem").combogrid('clear');
                $('#pharmacyItem').next().find('input').focus();
                $('.textbox-text').focus();
            }
        }


        var medicinePreviewRow = function (data) {
          
            $('#tbSelected').append('<tr ' + data.RowColour + '><td class="GridViewLabItemStyle" style="width:70px" ><span id="ItemCode">' + data.ItemCode +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:245px"><span id="spnItemName">' + data.ItemName +
                                        '</span><span id="spnSubCategoryID"  style="display:none" > ' + data.SubCategoryID + ' </span><span id="spnitemID" style="display:none" >' + data.ItemID +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnDose">' + data.Dose +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnTime">' + data.Time +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnDuration">' + data.Duration +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnRoute">' + data.Route +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnDoctorName">' + data.DoctorName +
                                        '</span></td><td class="GridViewLabItemStyle" style="width:120px" ><input type="text" class="ItDoseTextinputNum" id="spnQuantity" value="' + data.Quantity +
                                        '" /></td><td class="GridViewLabItemStyle" style="width:120px" ><span id="spnRemarks">' + data.Remarks +
                                        '</span><span id="spnunitType" style="display:none">' + data.unitType + '</span><span id="spnPatientMedicineID" style="display:none">' + data.PatientMedicine_ID + '</span><span id="spnDoctorID" style="display:none">' + data.DoctorID + '</span><span id="spnDepartmentID" style="display:none">' + data.departmentID + '</span></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td></tr>');

            $("#btnAddInv").removeAttr('disabled');
            $('#divSave,#tbSelected').show(); 
            $("#ddlDoctor").val(data.DoctorID).trigger("chosen:updated"); 
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
        function bindAdmissionDoctor() {
            $('#ddlDoctor option').remove();
            $.ajax({
                url: "../IPD/Services/IPDAdmission.asmx/bindAdmissionDoctor",
                data: '{}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = jQuery.parseJSON(mydata.d);
                    $("#ddlDoctor").append($('<option/>').val('0').html("Select"));
                    for (var i = 0; i < data.length; i++) {
                        $('#ddlDoctor').append($("<option></option>").val(data[i].DoctorID).html(data[i].Name));
                    }
                    $('#ddlDoctor').chosen();
                    
                }
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
                                $('#tbSelected').css('display', 'block');
                                var ItemCode = "", Remarks = "", SubCategoryID = "";
                                var unitType = jQuery.trim($rowid.find('#tdunittype').text());
                                $('#tbSelected').append('<tr ' + RowColour + '><td class="GridViewLabItemStyle"  ><span id="ItemCode">' + ItemCode +
                                                        '</span></td><td class="GridViewLabItemStyle" ><span id="spnItemName">' + ItemName +
                                                        '</span><span id="spnSubCategoryID"  style="display:none" > ' + SubCategoryID + ' </span><span id="spnitemID" style="display:none" >' + ItemID +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnDose">' + Dose +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnTime">' + Time +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnDuration">' + Duration +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnRoute">' + Route +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnDoctorID">' +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnQuantity">' + Quantity +
                                                        '</span></td><td class="GridViewLabItemStyle"  ><span id="spnRemarks">' + Remarks +
                                                        '</span><span id="spnunitType" style="display:none">' + unitType + '</span> <span id="spnunitType" style="display:none">' + 0 + '</span></td><td class="GridViewLabItemStyle" style="width:30px;text-align:center;"><img id="imgRemove" onclick="RemoveRows(this)"  src="../../Images/Delete.gif" style="cursor:pointer"/></td>');
                            }
                        }
                    }
                });
                $('#divSave').show();
                onMedicineSetIndentsModelClose();
            }
        }
        function SaveIndent() {
            if ($("#ddlDepartment").val() != "0") {
                if ($('#ddlDoctor').val() != "0") {

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
                            Obj.Quantity = Number($rowid.find("#spnQuantity").val());
                            Obj.Dose = jQuery.trim($rowid.find("#spnDose").text());
                            Obj.Time = jQuery.trim($rowid.find('#spnTime').text());
                            Obj.Duration = jQuery.trim($rowid.find('#spnDuration').text());
                            Obj.Route = jQuery.trim($rowid.find("#spnRoute").text());
                            Obj.TID = $('#spnTransactionID').text();
                            Obj.PID = $('#spnPatientID').text();
                            Obj.UnitType = jQuery.trim($rowid.find("#spnunitType").text());
                            Obj.Dept = $('#ddlDepartment').val();
                            Obj.IndentType = IndentType;
                            Obj.DoctorID = $('#ddlDoctor').val();
                            Obj.IPDCaseType_ID = $("#spnIPD_CaseTypeID").text();
                            Obj.Room_ID = $("#spnRoomID").text();
                            Obj.prescribeID = $rowid.find('#spnPatientMedicineID').text();
                            data.push(Obj);
                            Obj = new Object();
                        }
                    });

                    var zeroQuantityItems = data.filter(function (i) { return i.Quantity < 1 });
                    if (zeroQuantityItems.length > 0) {
                        modelAlert('Please Enter Valid Quantity.', function () { });
                        $('#btnSave').text('Save').attr('disabled', false);
                        return false;
                    }






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
                                if (Data == "1") {
                                    modelAlert('Record Saved Successfully', function () {
                                        ClearControls();
                                    });

                                }
                                else {
                                    modelAlert('Error Occurred', function () { });
                                }
                                $('#btnSave').text('Save').removeAttr('disabled');
                            },
                            error: function (xhr, status) {
                                modelAlert(status + "\r\n" + xhr.responseText);
                                $('#btnSave').text('Save').removeAttr('disabled');
                                window.status = status + "\r\n" + xhr.responseText;
                            }
                        });
                    }
                }else
                    modelAlert('Please Select Doctor');
            }
            else
                modelAlert('Please Select Department');
        }
        function ClearControls() {
            $("#tbSelected tr:not(#Header)").remove();
            $('#tbSelected').removeAttr('disabled').hide();
            $('#divSave').hide();
            $('#btnSave').removeAttr('disabled');
            bindAdmissionDoctor();
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
            bindAdmissionDoctor();
            LoadMedicineSet();
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
        function BindTimeForm() {
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
                        $('#ddlTime').append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Tim.length; i++) {
                            $('#ddlTime').append($("<option></option>").val(Tim[i].Quantity + '#' + Tim[i].NAME).html(Tim[i].NAME));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
        function BindDurationForm() {
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
                        $('#ddlDuration').append($("<option></option>").val("0").html("Select"));
                        for (i = 0; i < Dur.length; i++) {
                            $('#ddlDuration').append($("<option></option>").val(Dur[i].Quantity + '#' + Dur[i].NAME).html(Dur[i].NAME));
                        }
                    }
                },
                error: function (xhr, ajaxOptions, thrownError) {
                    jQuery("#lblMsg").text('Error occurred, Please contact administrator');
                }

            });
        }
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
            $('.textbox-prompt').attr('tabindex', 1);
        });

    </script>




    <script type="text/javascript">

        var openPrescriptionMedicines = function () {
            getPrescriptionMedicine(function () {
                $('#oldInvestigationModel').showModel();
            });
        }



        var getPrescriptionMedicine = function (callback) {
            var transactionID = $.trim($('#spnTransactionID').text());
            serverCall('PatientIndent.aspx/GetPrescriptionItems', { transactionID: transactionID }, function (response) {
                CPOEPrescripData = JSON.parse(response);
                var parseHTML = $('#template_searchOldInvestigation').parseTemplate(CPOEPrescripData);
                $('#divInvetigationPrescription').html(parseHTML);
                callback();
            });
        }



        var $addCPOEInvestigation = function (tblOldInvestigation) {
            $checkedInvestigation = tblOldInvestigation.find('tbody input[type=checkbox]:checked');
            if ($checkedInvestigation.length > 0) {

                var departmentID = $('#ddlDepartment').val();
                if (departmentID == '0') {
                    modelAlert('Please Select Department First.');
                    return;
                }


                var investigations = [];
                $checkedInvestigation.parent().parent().each(function () {
                    $data = JSON.parse($(this).find('#tdData').text());

                    //var data = {
                    //    RowColour: RowColour,
                    //    ItemCode: ItemCode,
                    //    ItemName: ItemName,
                    //    SubCategoryID: SubCategoryID,
                    //    ItemID: ItemID,
                    //    Dose: Dose,
                    //    Time: Time,
                    //    Duration: Duration,
                    //    Route: Route,
                    //    Quantity: Quantity,
                    //    Remarks: Remarks,
                    //    unitType: unitType
                    //}
                    $data.RowColour = '';
                    $data.departmentID = departmentID;
                    medicinePreviewRow($data);



                });
                $('#oldInvestigationModel').hideModel();
            }
            else
                modelAlert('Please Select Items.');

        }

    </script>




    <script id="template_searchOldInvestigation" type="text/html">
	<table class="GridViewStyle" cellspacing="0" width="100%" rules="all" border="1" id="tblOldInvestigation" style="width:100%;border-collapse:collapse;">
		<#if(CPOEPrescripData.length>0){#>

		<thead>
						   <tr  id='Tr2'>
								<th class='GridViewHeaderStyle'><input type='checkbox' id="chkAllOldInvestigation" onchange="$('#tblOldInvestigation tr td input[type=checkbox]').prop('checked',this.checked)" style="margin-left: 8px;" /></th>
								<th class='GridViewHeaderStyle'>S.No.</th>
								<th class='GridViewHeaderStyle'>Name</th>
								<th class='GridViewHeaderStyle'>Quantity</th>
								<th class='GridViewHeaderStyle'>Remarks</th>
						   </tr>
		</thead>
		 <#}#>
		<tbody>

		<#
		var dataLength=CPOEPrescripData.length;
		window.status="Total Records Found :"+ dataLength;
		var objRow;   
		var status;
		for(var j=0;j<dataLength;j++)
		{

		objRow = CPOEPrescripData[j];
		
		  #>
						<tr>
						<td id="td1" class="GridViewLabItemStyle" style="text-align:center"><input type="checkbox" onchange="$('#tblOldInvestigation tr td input[type=checkbox]:not(:checked)').length>0?$('#chkAllOldInvestigation').prop('checked',false):$('#chkAllOldInvestigation').prop('checked',true)" />  </td>
						<td id="tdIndex" class="GridViewLabItemStyle" style="text-align:center"><#=j+1#></td>
						<td id="tdData" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=JSON.stringify(objRow)#></td>
						<td id="tdTypename" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.ItemName#></td>
						<td id="tdQuantity" class="GridViewLabItemStyle" style="text-align:center"><#=objRow.Quantity#></td>
						<td id="td2" class="GridViewLabItemStyle" style="text-align:center;"><#=objRow.Remarks#></td>
						<td id="td3" class="GridViewLabItemStyle" style="text-align:center;display:none"><#=objRow.ItemID#></td>             
						</tr>   

			<#}#>
</tbody>
	 </table>    
	</script>


    <div id="oldInvestigationModel" class="modal fade" >
            <div class="modal-dialog">
                <div class="modal-content" style="width: 760px">
                    <div class="modal-header">
                        <button type="button" class="close" data-dismiss="oldInvestigationModel" aria-hidden="true">×</button>
                        <h4 class="modal-title">Prescription Medicines</h4>
                    </div>
                    <div class="modal-body">
                        <div style="height: 200px" class="row">
                            <div id="divInvetigationPrescription" style="max-height: 190px; overflow: auto" class="col-md-24">  

                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <%--<button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: lightgreen" class="circle"></button>--%>
                        <%--<b style="float: left; margin-top: 5px; margin-left: 5px">Issued Medicines</b>--%>
                        <button type="button" onclick="$addCPOEInvestigation($('#tblOldInvestigation'))">Add Medicine</button>
                        <button type="button" data-dismiss="oldInvestigationModel">Close</button>
                    </div>
                </div>
            </div>
        </div>


</body>
</html>
