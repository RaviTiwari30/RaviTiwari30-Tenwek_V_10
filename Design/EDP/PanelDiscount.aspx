<%@ Page Language="C#" AutoEventWireup="true" MasterPageFile="~/DefaultHome.master" CodeFile="PanelDiscount.aspx.cs" Inherits="Design_EDP_PanelDiscount" %>

<%@ Register Src="../Purchase/EntryDate.ascx" TagName="EntryDate" TagPrefix="uc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/jquery.blockUI.js"></script>
       <script type="text/javascript" src="../../Scripts/CheckboxSearch.js"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
        <script type="text/javascript" >
    
     $(document).ready(function () {
        getPanelGroup();   
        getPanel($.trim($("#ddlPanelGroup").val()));   
        
            $('#txtFromDate').change(function () {
                ChkDate();
            });
            $('#txtToDate').change(function () {
                ChkDate();
            });           
             $(".getpanel").change(function(){
                getPanel($.trim($("#ddlPanelGroup").val()));
            });
       });  
    
       
        
        function ChkDate() {
            $.ajax({
                url: "common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtFromDate').val() + '",DateTo:"' + $('#txtToDate').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata;
                    if (data == false) {
                        jQuery("#spnErrorMsg").text('To date can not be less than from date!');
                    }
                    else {
                        jQuery("#spnErrorMsg").text('');
                    }
                }
            });

        }
        function checkAllPatientType() {   
            var status = $('#<%= chkAllPatientType.ClientID %>').is(':checked');
            if (status == true) {
                $('.chkAllPatientTypeCheck input[type=checkbox]').attr("checked", "checked");
            }
            else {
                $(".chkAllPatientTypeCheck input[type=checkbox]").attr("checked", false);
            }
        }
        
        function chkPatientTypeCon() {
            if (($('#<%= chkPatientType.ClientID %>  input[type=checkbox]:checked').length) == ($('#<%= chkPatientType.ClientID %>  input[type=checkbox]').length)) {
                $('#<%= chkAllPatientType.ClientID %>').attr("checked", "checked");
            }
            else {
                $('#<%= chkAllPatientType.ClientID %>').attr("checked", false);
            }
        }
        
          
    function getPanelGroup() {
        $("#ddlPanelGroup option").remove();
        $.ajax({
            url: "Services/EDP.asmx/getPanelGroup",
            data: '{ }',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                PanelGroupData = $.parseJSON(result.d);
                if (PanelGroupData.length == 0) {
                    $("#ddlPanelGroup").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                 $("#ddlPanelGroup").append($("<option></option>").val("ALL").html("ALL"));
                    for (i = 1; i < PanelGroupData.length; i++) {                    
                        $("#ddlPanelGroup").append($("<option></option>").val(PanelGroupData[i].PanelGroup).html(PanelGroupData[i].PanelGroup));
                    }
                }
            },
            error: function (xhr, status) {
                $("#ddlPanelGroup").attr("disabled", false);
            }
        });
    }
    
    function getPanel(PnlGroup) {
        $("#ddlPanel option").remove();
        $.ajax({
            url: "Services/EDP.asmx/getPanel",
            data: '{PanelGroup:"' + PnlGroup + '"}',
            type: "POST",
            async: false,
            dataType: "json",
            contentType: "application/json; charset=utf-8",
            success: function (result) {
                PanelData = $.parseJSON(result.d);
                if (PanelData.length == 0) {
                    $("#ddlPanel").append($("<option></option>").val("0").html("---No Data Found---"));
                }
                else {
                    for (i = 0; i < PanelData.length; i++) {
                        $("#ddlPanel").append($("<option></option>").val(PanelData[i].PanelID).html(PanelData[i].Company_Name));
                    }                        
                }
            },
            error: function (xhr, status) {
                $("#ddlPanel").attr("disabled", false);
            }
        });
    }
    
      function SearchPanelDiscount() {
      var checked_checkboxes="";
      // checked_checkboxes = $("[id*=chkPatientType] input:checked");
      jQuery("#spnErrorMsg").text('');
            $.ajax({
                type: "POST",
                url: "Services/EDP.asmx/SearchPanelDiscount",
                data: '{PanelID:"' + $("#ddlPanel").val() + '",DateFrom:"' + $('#txtFromDate').val() + '",ToDate:"' + $('#txtToDate').val() + '",PatientType:"' + checked_checkboxes + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {

                    PanelDiscountDetail = response.d;
                    if (PanelDiscountDetail == "1") {
                        window.open('../common/ExportToExcel.aspx');
                    }
                    else {                      
                        jQuery("#spnErrorMsg").text('No Record Found');
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'spnErrorMsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        
        $(document).ready(function () {

            $(':file').on('change', function () {
                var file = this.files[0];
                if (file.size > 1024) {
                    alert('max upload size is 1024 kb')
                }
            });        

            $("#btnSave").click(function () {

                var Confirm = "Yes";
                if (jQuery("#tbSelected tr").length > 0) {                    
                    Confirm = confirm(jQuery("#tbSelected tr").length + " Records Found. Do You Want To Save ?")
                }

                if (Confirm) {

                    var Data = PanelDiscount();
                    jQuery.ajax({
                        url: "Services/EDP.asmx/SavePanelDiscount",
                        data: JSON.stringify({ ExcelData: Data }),
                        type: "Post",
                        contentType: "application/json; charset=utf-8",
                        timeout: "120000",
                        dataType: "json",
                        success: function (result) {
                            OutPut = result.d;
                            if (result.d == "1") {
                                jQuery("#spnErrorMsg").text(document.getElementById("fileUpload").files[0].name + ' File Uploaded Successfully');                                
                                // Upload();
                                jQuery('#fileUpload').empty();                                
                                jQuery('#btnSave').hide();
                                jQuery('#tbl').empty();
                                jQuery('#tbl').hide();
                                
                            }
                            else {
                                jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');
                                jQuery('#btnSave').attr('disabled', true).val("Save");
                            }
                        },
                        error: function (xhr, status) {
                            jQuery("#spnErrorMsg").text('Error occurred, Please contact administrator');

                            jQuery('#btnSave').attr('disabled', true).val("Save");
                        }
                    });

                }

            });
          
        });
        function PanelDiscount() {
            var dataObject = [];
            $('#tbSelected tr').each(function (index,elem) {
                var tds = $(this).find('td');
                var obj = {
                    PanelID: $(tds[0]).text(),
                    Panel: $(tds[1]).text(),
                    SubCategoryID: $(tds[2]).text(),
                    SubGroup: $(tds[3]).text(),
                    OPDDiscount: $(tds[4]).text(),
                    IPDDiscount: $(tds[5]).text(),
                }
                dataObject.push(obj);
            });
            return dataObject;
        }
        function Upload() {
            var fileUpload = document.getElementById("fileUpload");
            var regex = /^([a-zA-Z0-9\s_\\.\-:])+(.csv|.txt)$/;
            if (regex.test(fileUpload.value.toLowerCase())) {
                if (typeof (FileReader) != "undefined") {                   
                    var reader = new FileReader();
                    reader.onload = function (e) {
                        var table = document.createElement("table");
                        var rows = e.target.result.split("\n");
                        for (var i = 1; i < rows.length-1; i++) {
                            var row = table.insertRow(-1);
                            var cells = rows[i].split(",");
                            var opdDiscount, ipdDiscount;
                            for (var j = 0; j < 6; j++) {
                                var cell = row.insertCell(-1);
                                cell.innerHTML = cells[j];
                                if (j == 4)
                                    opdDiscount =parseInt(cells[j]);
                                if (j == 5)
                                    ipdDiscount = parseInt(cells[j]);                                
                            }
                           
                            if (opdDiscount == 0 && ipdDiscount == 0 || opdDiscount == null && ipdDiscount == null || opdDiscount == NaN && ipdDiscount == NaN || opdDiscount == '' && ipdDiscount == '' || opdDiscount == "" && ipdDiscount == "") {
                                row.style.backgroundColor = 'LightPink';
                            }
                        }

                        var dvCSV = document.getElementById("tbSelected");
                        dvCSV.innerHTML = "";
                        dvCSV.innerHTML = table.firstElementChild.innerHTML;

                        if (jQuery("#tbSelected tr").length > 1) {
                            jQuery("#btnSave").show();
                            jQuery('#tbl').show();
                        }
                        else {
                            jQuery("#btnSave").hide();
                            jQuery('#tbl').hide();
                        }

                    }
                    reader.readAsText(fileUpload.files[0]);
                } else {
                    alert("This browser does not support HTML5.");
                }
            } else {
                alert("Please upload a valid CSV file.");
            }
        }

    </script>
    

      <Ajax:ScriptManager id="ScriptManager1" runat="server"></Ajax:ScriptManager>
<div id="Pbody_box_inventory"  >
    <div class="POuter_Box_Inventory">
    <div class="content" style="text-align:center;">    
    <b>Panel Discount (OPD/IPD) </b><br />     <span id="spnErrorMsg" class="ItDoseLblError"></span>     
    </div>
    </div> <div class="POuter_Box_Inventory">
  
    </div>
    <div class="POuter_Box_Inventory">
        <div  style="text-align:center;">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Panel Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <select id="ddlPanelGroup" tabindex="1"  title="Select Panel"  class="getpanel"></select>
                        </div>
                          <div class="col-md-3">
                            <label class="pull-left">
                                Panel
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlPanel" tabindex="2"  title="Select Panel"></select>
                        </div>
                            <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table style="width: 100%">
                <tr style="display:none;" >
                    <td align="center" style="width: 25%; text-align: right" valign="top">
                        <asp:CheckBox ID="chkAllPatientType" runat="server" ClientIDMode="Static" onclick="checkAllPatientType();"  Text="PatientType :&nbsp;" />
                    </td>
                    <td align="center" colspan="3" style="text-align: left" valign="top">
                       <asp:CheckBoxList ID="chkPatientType" runat="server" ClientIDMode="Static"  Height="16px" onclick="chkPatientTypeCon()" CssClass="chkAllPatientTypeCheck ItDoseCheckboxlist" RepeatColumns="7" RepeatDirection="Horizontal" RepeatLayout="Table">
                          </asp:CheckBoxList>
                    </td>
                </tr>
              
            </table>
        </div>
    </div>
    
    <div class="POuter_Box_Inventory">
    <div  style="text-align: center">    
   <input type ="button" tabindex="3"   value="ExportToExcel" class="ItDoseButton" onclick="SearchPanelDiscount()" /></div>    
    </div>
      <div class="POuter_Box_Inventory">
     <div class="Purchaseheader">
     Upload CSV File
    </div>
    <div  style="text-align:left;">
        <table style="width:600px;">
                <tr>
                    <td align="left" style="width: 25%; text-align: right" valign="top">
                       Upload File :</td>
                    <td align="left" style="width:25%; text-align: left;" valign="top">
                       <input type="file" id="fileUpload" name="file" />
                    </td>

                    <td  align="left" style="width:50%; text-align: left;" valign="top" colspan="2">

                         <input type ="button" tabindex="4"  value="UploadExcel" class="ItDoseButton" onclick="Upload()"  />
                    
                    </td>

                </tr>

              <tr style="display:none;">
                    <td style="width: 25%; text-align: right" valign="top">
                        From Date :</td>
                    <td  style="width: 35%; text-align: left;" valign="top">
                        <asp:TextBox ID="txtFromDate" runat="server" ToolTip="Click To Select From Date"
                            Width="130px" TabIndex="5" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtFromDate_CalendarExtender" runat="server" TargetControlID="txtFromDate"
                            Format="dd-MMM-yyyy" >
                        </cc1:CalendarExtender>
                      </td>
                    <td  style="width: 25%; text-align: right" valign="top">
                        To Date :</td>
                    <td style="width: 35%; text-align: left;" valign="top">
                       <asp:TextBox ID="txtToDate" runat="server" ToolTip="Click To Select To Date" Width="130px"
                            TabIndex="6" ClientIDMode="Static"></asp:TextBox>
                        <cc1:CalendarExtender ID="txtToDate_CalendarExtender" runat="server" TargetControlID="txtToDate"
                            Format="dd-MMM-yyyy" >
                        </cc1:CalendarExtender>
                    </td>
                </tr>

        </table>
         <div class="Purchaseheader">
    CSV Data
    </div>
        <div style="overflow:auto; height:250px; ">
           
                 <table id="tbl"   rules="all" border="1" style="border-collapse: collapse; border-color:black; width: 100%; display:none; " class="GridViewStyle">
                     <thead>
                         <tr id="LabHeader">
                                    <th class="GridViewHeaderStyle" scope="col" >ID</th>
                                    <th class="GridViewHeaderStyle" scope="col" >Panel</th>
                                    <th class="GridViewHeaderStyle" scope="col" >SubGroupID</th>                                  
                                    <th class="GridViewHeaderStyle" scope="col" >SubGroup</th>
                                    <th class="GridViewHeaderStyle" scope="col" >OPDDiscount</th>
                                    <th class="GridViewHeaderStyle" scope="col" >IPDDiscount.</th>
                                    
                                </tr>
                     </thead>
                             <tbody id="tbSelected">

                             </tbody>  
                               
                            </table>

            </div>
        
        <div style="text-align:center;">

             <input type ="button" id="btnSave" tabindex="7"  style="display:none;"  value="Save" class="ItDoseButton"  />
        </div>


        </div>
    
    </div>
    </div>
    
            
        
    </asp:Content>
