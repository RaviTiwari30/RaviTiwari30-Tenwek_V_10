<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="TaxMaster.aspx.cs" Inherits="Design_TaxMaster" %>

<asp:Content ID="ct1" runat="server" ContentPlaceHolderID="ContentPlaceHolder1">

     <style type="text/css">
         .select_bdr_validation button{
    border-bottom-color: red !important;
    border-bottom-width: 2px !important;
}
     </style>
    <script type="text/javascript">

        $(function () {
            $('.multiselect').multipleSelect({
                filter: true, keepOpen: false, width: 100
            });
            $('.multiselectitems').multipleSelect({
                selectAll: false,
                filter: true,
                keepOpen: false,
                width: 100
            });
            $(".multiselect,.multiselectitems").width('100%');


            $bindTaxServiceMaster(function () { });
            bindTaxMaster(0, function () {

            });
        });
        $.fn.listbox = function (params) {
            try {
                var elem = this.empty();
                if (params.defaultValue != null || params.defaultValue != '')
                    $.each(params.data, function (index, data) {
                        var dataAttr = {};
                        var option = $(new Option).val(params.valueField === undefined ? this.toString() : this[params.valueField]).text(params.textField === undefined ? this.toString() : this[params.textField]).attr('data', JSON.stringify(dataAttr));
                        $(params.customAttr).each(function (i, d) { $(option).attr(d, data[d]); });
                        elem.append(option);

                    });
                if (params.selectedValue != null || params.selectedValue != '' || params.selectedValue != undefined)
                    $(elem).val(params.selectedValue);


                if (params.isSearchAble || params.isSearchable) {
                    $(elem).multipleSelect({
                        includeSelectAllOption: true,
                        filter: true, keepOpen: false
                    });
                }
            } catch (e) {
                console.error(e.stack);
            }
        }
        function Getmultiselectvalue(controlvalue) {
            var DepartmentID = "";
            var input = "";
            var SelectedLaength = $(controlvalue).multipleSelect("getSelects").join().split(',').length;
            if (SelectedLaength > 1)
                DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
            else {
                if ($(controlvalue).val() != null) {
                    DepartmentID = '\'' + $(controlvalue).multipleSelect("getSelects").join('\',\'').split(',') + '\'';
                }
            }
            return DepartmentID;
        }
        $bindTaxServiceMaster = function (callBack) {
            serverCall('TaxMaster.aspx/bindTaxServiceMaster', {}, function (response) {
                if (response != "") {
                    var lstServiceWise = $('#lstServiceWise');
                    var lstBillWise = $('#lstBillWise');
                    lstServiceWise.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Value', textField: 'Name', isSearchAble: true, isRequired: true });
                    lstBillWise.listbox({ defaultValue: 'Select', data: JSON.parse(response), valueField: 'Value', textField: 'Name', isSearchAble: true, isRequired: true });

                 
                }
                else {
                    modelAlert('No Record Found');
                }
                callBack(true);
            });
        }


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
            var data = {
                TaxID: $('#spnTaxMasterID').val(),
                TaxName: $('#txtname').val(),
                IsDefault: $('input[type=radio][name=rdoDefault]:checked').val(),
                IsItemRateWithTax: $('input[type=radio][name=rdoRate]:checked').val(),
                Savetype: $('#btnSave').val(),
                IsServiceWise: Getmultiselectvalue($('#lstServiceWise')),
                IsBillWise: Getmultiselectvalue($('#lstBillWise')),
            }
            if (String.isNullOrEmpty(data.TaxName)) {
                modelAlert('Please Enter Tax Name', function () {
                    $('#txtname').focus();
                });
                return false;
            }
            if (String.isNullOrEmpty(data.IsServiceWise)) {
                modelAlert('Please Select Print Service Wise Tax', function () {
                    $('#lstServiceWise').focus();
                });
                return false;
            }

            if (String.isNullOrEmpty(data.IsBillWise)) {
                modelAlert('Please Select Print Bill Wise Tax', function () {
                    $('#lstBillWise').focus();
                });
                return false;
            }
            


            serverCall('TaxMaster.aspx/SaveTaxMaster', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    bindTaxMaster(0, function () {
                        Clear();
                    });
                });
            });
        }

        var bindTaxMaster = function (vTaxID, callback) {
           
            serverCall('TaxMaster.aspx/bindTaxMaster', { TaxID: vTaxID }, function (response) {
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
                row += '<td id="tdIsDefault" style="display:none;" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IsDefault + '</td>';
                row += '<td id="tdDefault"  class="GridViewLabItemStyle" style="text-align: center;">' + data[i].vDefault + '</td>';
                row += '<td id="tdIsItemRateWithTax" style="display:none;" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].IsItemRateWithTax + '</td>';
                row += '<td id="tdItemRateWithTax" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ItemRateWithTax + '</td>';
                row += '<td id="tdAID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TaxId + '</td>';
                row += '<td id="tdServiceWise" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].ServiceWise + '</td>';
                row += '<td id="tdBillWise" class="GridViewLabItemStyle" style="text-align: center;">' + data[i].BillWise + '</td>';
                row += '<td id="tdIsServiceWise" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsServiceWise + '</td>';
                row += '<td id="tdIsBillWise" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].IsBillWise + '</td>';
                row += '<td class="GridViewLabItemStyle" style="text-align: center;"><img id="imgEdit" src="../../Images/edit.png" onclick="Edit(this);" style="cursor: pointer;" title="Click To Edit" /></td>';

                //row += '<td id="lblMasterID" class="GridViewLabItemStyle" style="text-align: center; display:none">' + data[i].TaxId + '</td>';
                row += '</tr>';
                $('#tbTaxlist tbody').append(row);
            }
        }
        var Edit = function (rowID) {


            var row = $(rowID).closest('tr');
            $('#txtname').val(row.find('#tdTaxName').text());
            $('input[type=radio][name=rdoDefault][value=' + row.find('#tdIsDefault').text() + ']').prop('checked', true);
            $('input[type=radio][name=rdoRate][value=' + row.find('#tdIsItemRateWithTax').text() + ']').prop('checked', true);
            $('#spnTaxMasterID').val(row.find('#tdAID').text());


            $('#btnSave').val('Update');

            var IsServiceWise = row.find('#tdIsServiceWise').text();
            var IsBillWise = row.find('#tdIsBillWise').text();

            var IsServiceWise=IsServiceWise.split(",");
            $.each(IsServiceWise, function (index, value) {
                var nv = value.split('#');
                if (nv.length > 0) {
                    if (nv[1] == "1")
                        $("#<%=lstServiceWise.ClientID %> option[value=" + nv[0] + "]").attr("selected", true);
                }
            });
            $("#<%=lstServiceWise.ClientID %>").multipleSelect("refresh");

            var IsBillWise = row.find('#tdIsBillWise').text().split(',');
            $.each(IsBillWise, function (index, value) {
                var nv = value.split('#');
                if (nv.length > 0) {
                    if (nv[1] == "1")
                        $("#<%=lstBillWise.ClientID %> option[value=" + nv[0] + "]").attr("selected", true);
                }
            });
            $("#<%=lstBillWise.ClientID %>").multipleSelect("refresh");
          

            //var service = lstServiceWise.Split(',').ToArray();


        }
        var Clear = function () {
            $('#txtname').val('');
            $('input[type=radio][name=rdoDefault][value=1]').prop('checked', true);
            $('input[type=radio][name=rdoRate][value=1]').prop('checked', true);
            $('#spnTaxMasterID').text('');

            $bindTaxServiceMaster(function () { });
            $("#<%=lstServiceWise.ClientID %>").multipleSelect("refresh");
            $("#<%=lstBillWise.ClientID %>").multipleSelect("refresh");
            $('#btnSave').val('Save');
        }

    </script>
    <style type="text/css">
        div.dd_chk_select {
            display: block !important;
            border-radius: 4px;
            height: 25px !important;
        }

            div.dd_chk_select div#caption {
                top: 3px;
            }
        
    </style>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>TAX MASTER</b>
            <label id="lblMasterID" style="display:none"></label>
            <span style="display: none" id="spnTaxMasterID"></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Enter Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Tax Name </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">

                    <input type="text" id="txtname" class="requiredField" placeholder="Search by First Name" />
                </div>
                <div class="col-md-3">
                    <label class="pull-left">Is Default Tax </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="radio" name="rdoDefault" value="1" checked="checked" />Yes
                            <input type="radio" name="rdoDefault" value="2" />No
                                        
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Print Service Wise Tax </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstServiceWise"  CssClass="multiselect select_bdr_validation" SelectionMode="Multiple" runat="server" ClientIDMode="Static"  ></asp:ListBox>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Print Bill Wise Tax </label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <asp:ListBox ID="lstBillWise"  CssClass="multiselect select_bdr_validation" SelectionMode="Multiple" runat="server" ClientIDMode="Static"></asp:ListBox>
                </div>


                <div class="col-md-3">
                    <label class="pull-left">Is Tax On Rate</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-4">
                    <input type="radio" name="rdoRate" value="1" checked="checked" />Inclusive 
                            <input type="radio" name="rdoRate" value="2" />Exclusive 
                </div>
                <div class="col-md-4">
                    <label class="pull-left">Bill Max Length</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                   <label class="pull-left"> <%= Resources.Resource.BillMaxLength %> </label>
                </div>
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Receipt Max Length</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <label class="pull-left"><%= Resources.Resource.ReceiptMaxLength %></label>
                </div>
            </div>


        </div>

        <div class="POuter_Box_Inventory">
            <div class="row" style="text-align: center">
                <input type="button" id="btnSave" value="Save" onclick="Save()" />
                <input type="button" id="btnClear" value="Clear" onclick="Clear()" />
                <%--    <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click" />
                <asp:Button ID="btnClear" runat="server" Text="Clear" />--%>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Tax Details
            </div>
            <div class="row">
                <div class="col-md-3">
                    <label class="pull-left">Search Tax Name</label>
                    <b class="pull-right">:</b>
                </div>
                <div class="col-md-5">
                    <input type="text" id="txtsearch" onkeyup="SearchbyfirstName(this)" placeholder="Search by Tax Name" />
                </div>
            </div>
            <div class="row">
                <div id="divList" style="max-height: 500px; overflow-x: auto">
                    <table class="FixedHeader" id="tbTaxlist" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                        <thead>
                            <tr>
                                <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Tax Name</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Is Default</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Is Tax On Rate</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Service Wise Tax</th>
                                <th class="GridViewHeaderStyle" style="width: 150px;">Bill Wise Tax</th>
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

