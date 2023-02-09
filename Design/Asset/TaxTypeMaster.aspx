<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TaxTypeMaster.aspx.cs" Inherits="Design_Asset_TaxTypeMaster" %>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

    <script type="text/javascript">
        $(document).ready(function () {
            bindTaxTypeMaster(0, function () {
           
            });
        });

        var SearchbyfirstName = function (elem) {
            var name = $.trim($(elem).val());
            var length = $.trim($(elem).val()).length;

            $('#tbTaxlist tr').hide();
            $('#tbTaxlist tr:first').show();
            $('#tbTaxlist tr').find('td:eq(1)').filter(function () {
                if ($(this).text().substring(0, length).toLowerCase() == name.toLowerCase())
                    return $(this);
            }).parent('tr').show();;
        }

        var Save = function () {
         
            var TaxName = $("#<%=ddlname.ClientID %>").val();
            var TaxFormulaID = $("#<%=ddlFormula.ClientID %>").val();
            var data = {
                TaxID: $('#spnTaxMasterID').val(),
                TaxName:TaxName,
                TaxType: $('#txtType').val(),
                TaxFormulaId: TaxFormulaID,
                IsActive: $('input[type=radio][name=rdoactive]:checked').val(),
         
                Savetype: $('#btnSave').val(),

            }

            if (String.isNullOrEmpty(data.TaxName)) {
                modelAlert('Please Select Name', function () {
                    $("#ddlname").focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data.TaxType)) {
                modelAlert('Please Select Tax Type', function () {
                    $('#txtType').focus();
                });
                return false;
            }

            if (String.isNullOrEmpty(data.TaxFormulaId)) {
                modelAlert('Please Select Formula', function () {
                    $("#ddlFormula").focus();
                });
                return false;
            }

            serverCall('TaxTypeMaster.aspx/SaveTaxTypeMaster', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindTaxTypeMaster(0, function () {
                        Clear();
                    });
                });
            });
        }

        var bindTaxTypeMaster = function (vTaxID, callback) {
            serverCall('TaxTypeMaster.aspx/bindTaxTypeMasterDetails', { ID: vTaxID }, function (response) {
                var responseData = JSON.parse(response);
                bindDetails(responseData);
            });
            callback(true);
        }
        var bindDetails = function (data) {

            $('#tbTaxlist tbody').empty();
            for (var i = 0; i < data.length; i++) {
                var j = $('#tbTaxlist tbody tr').length + 1;
                var row = '<tr>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdTaxName" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TaxName + '</td>';
                row += '<td id="tdTaxType" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TaxType + '</td>';
                row += '<td id="tdTaxFormulaId" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].TaxFormulaId + '</td>';
                row += '<td id="tdIsActiveValue" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IsActiveValue + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].ID + '</td>';
                row += '<td id="tdFID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].FormulaId + '</td>';
                row += '<td id="tdIsActive" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].Isactive + '</td>';
                row += '</tr>';
                $('#tbTaxlist tbody').append(row);
            }
        }

        var Edit = function (rowID) {
            debugger;
            var row = $(rowID).closest('tr');
            $('#<%=ddlname.ClientID %>').val(row.find('#tdTaxName').text()).chosen("destroy").chosen();
            $('#txtType').val(row.find('#tdTaxType').text());
            $('#<%=ddlFormula.ClientID %>').val(row.find('#tdFID').text()).chosen("destroy").chosen();
            $('input[type=radio][name=rdoactive][value=' + row.find('#tdIsActive').text() + ']').prop('checked', true);
            $('#spnTaxMasterID').val(row.find('#tdFID').text());

            $('#btnSave').val('Update');
        }
    
        var Clear = function () {
            $('#<%=ddlname.ClientID %>').val(0).chosen("destroy").chosen();
            $('#txtType').val('');
            $('#<%=ddlFormula.ClientID %>').val(0).chosen("destroy").chosen();
            $('input[type=radio][name=rdoactive][value=1]').prop('checked', true);
            $('#spnTaxMasterID').text('');

            $('#btnSave').val('Save');
        }
        </script>
<div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>TAX TYPE MASTER</b>
            <span style="display:none" id="spnTaxMasterID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Tax Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlname" runat="server" CssClass="requiredField"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Tax Type</label>
                            <b class="pull-right">:</b>
                        </div>
                             <div class="col-md-5">
                            <input type="text" id="txtType"  class="requiredField"  />
                        </div>                                           
                        <div class="col-md-3">
                            <label class="pull-left">Default Formula</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlFormula" runat="server" CssClass="requiredField"></asp:DropDownList>
                        </div>
                        </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Is Active</label>
                            <b class="pull-right">:</b>
                        </div>
                         <div class="col-md-5">
                             <input type="radio" name="rdoactive" value="1" checked="checked" />Yes
                            <input type="radio" name="rdoactive" value="2" />No
                        </div>
                        </div>              
                    </div>
                </div>
                 <div class="col-md-1"></div>
            </div>
        
        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSave" value="Save" onclick="Save()" />
                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />
                
            </div>
        </div>
    <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Tax Details
            </div>
         <div class="row">
                <div class="col-md-3">
                            <label class="pull-left"> Search Tax Name</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <input type="text" id="txtsearch" onkeyup="SearchbyfirstName(this)" placeholder="Search by Tax name" />
                        </div>
            </div>
            <div class="row">
                <div id="divList" style="max-height: 500px; overflow-x: auto">
                    <table class="FixedHeader" id="tbTaxlist" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Tax Name</th>
                                <th class="GridViewHeaderStyle" style="width: 80px;">Tax Type</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Default Formula</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Is Active</th>
                                <th class="GridViewHeaderStyle" style="width: 100px;">Edit</th>
                            </tr>
                        </thead>
                        <tbody></tbody>
                    </table>
                </div>
            </div>
        </div>
        </div>
</asp:Content>
