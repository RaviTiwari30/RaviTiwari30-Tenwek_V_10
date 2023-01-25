<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="RequestBloodTransfertoCentre.aspx.cs" Inherits="Design_BloodBank_RequestBloodTransfertoCentre" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
     <script type="text/javascript" src="../../Scripts/Search.js"> </script>
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script  src="../../Scripts/json2.js" type="text/javascript"></script>
      
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Centre Stock Transfer Request </b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" />
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader" runat="server">
                Search Criteria
            </div>
                <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                       <div class="col-md-3">
                            <label class="pull-left">
                                Centre Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlCentre" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Centre" ></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Component
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                           <select id="ddlComponent" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Component"></select>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <select id="ddlBloodGroup" style="border-bottom-color: red; border-bottom-width: 2px" title="Select Blood Group"></select>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
             <input type="button" id="btnAdd" value="Add" tabindex="4" class="ItDoseButton" onclick="Add();" />
             </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display:none;" id="divRequest">
              <table class="GridViewStyle"    rules="all" border="1" id="tb_grdLabSearch" style="width:100%;  border-collapse: collapse; display: none;">
                            <tr id="RHeader">
                                <th class="GridViewHeaderStyle" scope="col" style="width: 40px;">S.No.
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Centre Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 200px;">Component Name
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Blood Group
                                </th>  
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Quantity
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 100px;">Reason
                                </th>
                                <th class="GridViewHeaderStyle" scope="col" style="width: 70px;">Remove
                                </th>
                            </tr>
                        </table>
                     
         </div>
       
        <div class="POuter_Box_Inventory" style="text-align: center; display:none;" id="divSave">
                     <input type="button" id="btnSave" value="Send Request" tabindex="5" class="ItDoseButton" onclick="SaveRequest();" />
         </div>
        <div class="POuter_Box_Inventory" style="text-align: center; display:none;" id="divRequstStatus">
             <div class="Purchaseheader">
                Request Status
            </div>
<%--            <div>
            <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #28b779" class="circle"></button>
            <b style="float: left; margin-top: 5px; margin-left: 5px">Issued</b>
            <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #ff6a00" class="circle"></button>
            <b style="float: left; margin-top: 5px; margin-left: 5px">Reject</b>
            <button type="button" style="width: 30px; height: 30px; float: left; margin-left: 5px; background-color: #0063ff" class="circle"></button>
            <b style="float: left; margin-top: 5px; margin-left: 5px">Pending</b>
                </div>--%>
                  <div id="StockOutput" style="max-height: 500px; overflow-x: auto;">
                      
                  </div>
         </div>
    </div>
    <script type="text/javascript">
        $(document).ready(function () {
            LoadCentre();
            LoadComponent();
            LoadBloodGroup();
        });
        function LoadCentre() {
            serverCall('RequestBloodTransfertoCentre.aspx/LoadCentre', {}, function (response) {
                ddlCentre = $('#ddlCentre');
                ddlCentre.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false });
            });
        }
        function LoadComponent() {
            serverCall('RequestBloodTransfertoCentre.aspx/LoadComponent', {}, function (response) {
                ddlComponent = $('#ddlComponent');
                ddlComponent.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'ComponentName', isSearchAble: false });
            });
        }
        function LoadBloodGroup() {
            serverCall('RequestBloodTransfertoCentre.aspx/LoadBloodGroup', {}, function (response) {
                ddlBloodGroup = $('#ddlBloodGroup');
                ddlBloodGroup.bindDropDown({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'ID', textField: 'BloodGroup', isSearchAble: false });
            });
        }
        function ChangeColor(rowID) {
            $(rowID).closest('tr').find('#chkYes').css("background-color", "#FDE76D");
        }
    </script>
    <script type="text/javascript">
        function Add() {

            var CentreID = $('#ddlCentre option:selected').val();
            var CentreName = $('#ddlCentre option:selected').text()
            var ComponentID = $('#ddlComponent option:selected').val();
            var ComponentName = $('#ddlComponent option:selected').text();
            var BloodGroupID = $('#ddlBloodGroup option:selected').val();
            var BloodGroup = $('#ddlBloodGroup option:selected').text();

            if (CentreID == "0") {
                modelAlert('Please Select Centre !!');
                return false;
            }
            if (ComponentID == "0") {
                modelAlert('Please Select Component !!');
                return false;
            }
            if (BloodGroupID == "0") {
                modelAlert('Please Select BloodGroup !!');
                return false;
            }

            var chkDup = ComponentID + '#' + BloodGroupID;
            RowCount = $("#tb_grdLabSearch tr").length;
            RowCount = RowCount + 1;

            var AlreadySelect = 0;
            if (RowCount > 2) {
                $("#tb_grdLabSearch tr").each(function () {
                    if ($(this).attr("id") == 'tr_' + chkDup) {
                        AlreadySelect = 1;
                        return;
                    }
                });
            }
            if (AlreadySelect == "0") {
                var newRow = $('<tr />').attr('id', 'tr_' + chkDup);
                newRow.html('<td class="GridViewLabItemStyle" >' + (RowCount - 1) +
                     '</td><td class="GridViewLabItemStyle" style="display:none;" id=td_CentreId >' + CentreID +
                     '</td><td class="GridViewLabItemStyle" style="text-align:center" id=td_CentreName >' + CentreName +
                     '</td><td  class="GridViewLabItemStyle" style="text-align:center;display:none;" id=td_ComponentID >' + ComponentID +
                     '</td><td  class="GridViewLabItemStyle"  id=td_ComponentName >' + ComponentName +
                     '</td><td  class="GridViewLabItemStyle"  id=td_BloodGroup >' + BloodGroup +
                     '</td><td  class="GridViewLabItemStyle"  id=td_Qty ><input type="text" id="txtQty" style="width:100px; border-bottom-color: red; border-bottom-width: 2px" onkeyup="CheckNumeric(this);" />' +
                     '</td><td  class="GridViewLabItemStyle"  id=td_Reason ><input type="text" id="txtReason" />' +
                     '</td><td class="GridViewLabItemStyle" style="text-align:center"><img id="imgRmv" src="../../Images/Delete.gif" onclick="DeleteRow(this);" title="Click To Remove" /></td>'
                    );
                $("#tb_grdLabSearch").append(newRow);
                $("#tb_grdLabSearch").show();
                $('#divRequest').show();
                $('#divSave').show();
                $('#ddlCentre').prop('disabled', true) ;
            }
            else {
                modelAlert('Component Already Added of Same Blood Group !!!');
            }
        }

        function DeleteRow(rowid) {
            var row = rowid;
            $(row).closest('tr').remove();
            RowCount = RowCount - 1;
            if ($("#tb_grdLabSearch tr").length == "1") {
                $("#tb_grdLabSearch").hide();
                $('#ddlCentre').prop('disabled', false);
                $('#divSave').hide();
            }
        }

        function SaveRequest() {
            if (validate() == true) {
                var dataStk = new Array();
                var ObjDtStk = new Object();
                $('#tb_grdLabSearch tr').each(function () {
                    var id = jQuery(this).attr("id");
                    var $rowid = $(this).closest("tr");
                    if (id != "RHeader") {
                        ObjDtStk.CentreID = $.trim($rowid.find("#td_CentreId").text());
                        ObjDtStk.ComponentID = $.trim($rowid.find("#td_ComponentID").text());
                        ObjDtStk.ComponentName = $.trim($rowid.find("#td_ComponentName").text());
                        ObjDtStk.BloodGroup = $.trim($rowid.find("#td_BloodGroup").text());
                        ObjDtStk.Reason = $.trim($rowid.find("#txtReason").val());
                        ObjDtStk.Quantity = $.trim($rowid.find("#txtQty").val());
                        dataStk.push(ObjDtStk);
                        ObjDtStk = new Object();
                    }
                });
                if (dataStk.length > 0) {
                    $.ajax({
                        url: "RequestBloodTransfertoCentre.aspx/SaveRequest",
                        data: JSON.stringify({ Data: dataStk }),
                        type: "POST", // data has to be Posted    	        
                        contentType: "application/json; charset=utf-8",
                        timeout: 120000,
                        dataType: "json",
                        async: false,
                        success: function (result) {
                            Data = result.d;
                            if (Data == "1") {
                                $('#ddlCentre').prop('disabled', false);
                                LoadCentre();
                                LoadComponent();
                                LoadBloodGroup();
                                modelAlert('Record Save Successfully');
                                $('#tb_grdLabSearch tr:not(:first)').remove();
                                $('#tb_grdLabSearch').hide();
                                $('#divSave').hide();
                                $('#divRequest').hide();
                            }
                            else {
                                modelAlert('Record Not Saved');
                            }
                        },
                        error: function (xhr, status) {

                        }
                    });
                }
            }
        }
        function CheckNumeric(Qty) {
            var Amt = $(Qty).val();
            if (Amt.charAt(0) == "0") {
                $(Qty).val(Number(Amt));
            }

            if (Amt.match(/[^0-9\.]/g)) {
                Amt = Amt.replace(/[^0-9\.]/g, '');
                $(Qty).val(Number(Amt));
                return;
            }
            if (Amt.indexOf('.') != -1) {
                var DigitsAfterDecimal = 2;
                var valIndex = Amt.indexOf(".");
                if (valIndex > "0") {
                    if (Amt.length - (Amt.indexOf(".") + 1) > DigitsAfterDecimal) {
                        alert("Only " + DigitsAfterDecimal + " Digits Are Allowed After Decimal");
                        $(Qty).val($(Qty).val().substring(0, ($(Qty).val().length - 1)));

                    }
                }
            }
        }

        function validate() {
            var con = 0; 
            $('#tb_grdLabSearch tr').each(function () {
                var id = jQuery(this).attr("id");
                var $rowid = $(this).closest("tr");
                if (id != "RHeader") {
                    if (Number($.trim($rowid.find("#txtQty").val())) == 0) {
                        modelAlert('Please Enter Quantity');
                        $rowid.find("#txtQty").focus();
                        con = 1;
                        return false;
                    }
                }
            });
            if (con == "1") {
                return false;
            }
            return true;
        }
    </script>
  
</asp:Content>