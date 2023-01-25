<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PanelAmountAllocation.aspx.cs" Inherits="Design_IPD_PanelAmountAllocation" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
    <title>Untitled Page</title>
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
    <%@ Register Src="~/Design/Controls/wuc_IPDBillDetail.ascx" TagName="PatientIPDBillDetails" TagPrefix="UCPatientIPDBillDetails" %>
</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>

    <script type="text/javascript">

       
        $(document).ready(function () {
            $('#ddlPanel').chosen();
        });

        var addDispatchAmount = function () {
            var panelID = Number($('#ddlPanel').val().split('#')[0]);
            var panelName = $('#ddlPanel option:selected').text();
            var data = {
                panelID: panelID,
                panelName: panelName,
                allocatedAmount: 0,
                IsSmartCard:0
            }

            addPanelAllocationDetailsRow(data, true, function () {});
        }


        var addPanelAllocationDetailsRow = function (data, isNewRow, callback) {

            var tableToAppend = $('#divSelectedAllocationDetails table tbody');
            var totalRowLength = tableToAppend.find('tr').length;

            var isAlredyAdded = tableToAppend.find('#' + data.panelID).length;

            if (isAlredyAdded > 0) {
                modelAlert('Panel Already Added.', function () { });
                return false;
            }


            var row = '<tr id="' + data.panelID + '">';
            row += '<td class="GridViewLabItemStyle textCenter">' + (totalRowLength + 1) + '</td>';
            row += '<td class="GridViewLabItemStyle">' + data.panelName + '</td>';
            row += '<td class="GridViewLabItemStyle textCenter">' + data.allocatedAmount + '</td>';
            row += '<td class="GridViewLabItemStyle textCenter" style="display:none" id="tdData" >' + JSON.stringify(data) + '</td>';
            
            if (data.IsSmartCard==1) {
                row += '<td class="GridViewLabItemStyle"><input type="text" id="txtAmountToAllocate" class="ItDoseTextinputNum"  /> </td>';

            } else {
                row += '<td class="GridViewLabItemStyle"><input type="text" id="txtAmountToAllocate" class="ItDoseTextinputNum"  /> </td>';

            }

          
            row += '<td class="GridViewLabItemStyle"><select><option value="CR">Credit</option> <option value="DR">Debit</option> </select>   </td>';
            row += '<td class="GridViewLabItemStyle textCenter">' + data.EmpName + '</td>';
            row += '<td class="GridViewLabItemStyle textCenter">';

            if (isNewRow)
                row += '<img style="cursor:pointer" alt="X" src="../../Images/Delete.gif" onclick="onRemoveSelectedRow(this)" /> ';

            row += '</td>';
            tableToAppend.append(row);
            callback();
        }

        var onRemoveSelectedRow = function (el) {
            $(el).closest('tr').remove();
        }


        var getPanelAmountAllocationDetails = function (callback) {
            var panelAmountAllocationDetails = [];
            var transactionID = $.trim($('#lblTID').text());
            $('#divSelectedAllocationDetails table tbody tr').each(function () {
                var row = this;
                var rowData = JSON.parse($(this).find('#tdData').text());
                var panelID = rowData.panelID;
                var amount = Number($(this).find('#txtAmountToAllocate').val());
                var allocationType = $.trim($(this).find('select').val());
                if (amount > 0) {
                    panelAmountAllocationDetails.push({
                        panelID: panelID,
                        transactionID: transactionID,
                        amount: amount,
                        allocationType: allocationType
                    });
                }
            });

            if (panelAmountAllocationDetails.length < 1) {
                modelAlert('Please Enter Allocation Amount.', function () { });
                return false;
            }

            callback(panelAmountAllocationDetails);

        }



        var savePanelAmountAllocationDetails = function (btnSave) {

            var totalNetBillAmount = Number($('#ass_lblNetBillAmt').text());
            getPanelAmountAllocationDetails(function (data) {
                $(btnSave).attr('disabled', true).val('Submitting...');
                serverCall('PanelAmountAllocation.aspx/SavePanelAmountAllocationDetails', { panelAllocationDetails: data, totalNetBillAmount: totalNetBillAmount }, function (response) {
                    var resposneData = JSON.parse(response);
                    modelAlert(resposneData.message, function () {
                        if (resposneData.status)
                            window.location.reload();
                        else
                            $(btnSave).removeAttr('disabled').val('Save');
                    });
                });
            });
        }




        var getPatientPanelAmountAllocationDetails = function (callback) {
            var data = {
                transactionID: $.trim($('#lblTID').text())
            }
            serverCall('PanelAmountAllocation.aspx/GetPatientPanelAmountAllocationDetails', data, function (response) {
                var responseData = JSON.parse(response);
                $(responseData).each(function () {
                    addPanelAllocationDetailsRow(this, false, function () { });
                });
            });
            callback();
        }


        $(document).ready(function () {
            getPatientPanelAmountAllocationDetails(function () {});
        });



    </script>

    <form id="form1" runat="server">
        <cc1:ToolkitScriptManager runat="server" ID="scrScriptmanager"></cc1:ToolkitScriptManager>
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content textCenter">
                    <b>Panel Amount Allocation</b>
                    <asp:Label ID="lblTID" runat="server" Style="display: none" ClientIDMode="Static"></asp:Label>
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Patient Bill Details
                </div>
                <UCPatientIPDBillDetails:PatientIPDBillDetails runat="server" ID="ass" />
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Add Panel Details
                </div>

                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Panel Company </label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        

                        <asp:DropDownList runat="server" ID="ddlPanel" ClientIDMode="Static"></asp:DropDownList>

                    </div>


                    <div class="col-md-3">
                        <input type="button" value="Add Panel" class="save" onclick="addDispatchAmount(this);" />
                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Panel Amount Allocation Details
                </div>
                <div class="row">
                    <div class="col-md-24" id="divSelectedAllocationDetails">
                        <table cellspacing="0" style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 50px">#</th>
                                    <th class="GridViewHeaderStyle">Panel</th>
                                    <th class="GridViewHeaderStyle" style="width: 145px">Allocated Amount</th>
                                    <th class="GridViewHeaderStyle" style="width: 100px">Amount</th>
                                    <th class="GridViewHeaderStyle" style="width: 125px">Dispatch Type
                                    </th>
                                    <th class="GridViewHeaderStyle" style="width: 125px">Entry By
                                    </th>
                                    <th class="GridViewHeaderStyle" style="width: 36px"></th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>

            <div class="POuter_Box_Inventory textCenter">
                <input type="button" id="btnSave" value="Save" onclick="savePanelAmountAllocationDetails(this);" class="save margin-top-on-btn" />

            </div>
        </div>
    </form>
</body>
</html>
