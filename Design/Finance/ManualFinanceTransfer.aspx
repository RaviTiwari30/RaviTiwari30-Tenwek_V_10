<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="ManualFinanceTransfer.aspx.cs" Inherits="Design_Finance_ManualFinanceTransfer" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <cc1:ToolkitScriptManager ID="pageScripptManager" runat="server"></cc1:ToolkitScriptManager>
        <div class="POuter_Box_Inventory textCenter">

            <b>Manual Finance Transfer</b>

        </div>
        <div class="POuter_Box_Inventory">


            <div class="Purchaseheader">
                Centre & Transfer Type
                <asp:Label ID="lblMsg" runat="server"  BackColor="Red" Font-Bold="true"></asp:Label>
            </div>

            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">

                    <div class="row">


                        <div class="col-md-3">
                            <label class="pull-left">Center</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <%--<select id="ddlCentre" onchange="onFilterTypeChange(this)"></select>--%>
                            <asp:DropDownList ID="ddlCentre" onchange="onFilterTypeChange(this)" runat="server" ClientIDMode="Static"></asp:DropDownList>

                            <asp:Label ID="lblCentreID" runat="server" style="display:none" ClientIDMode="Static"> </asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Transfer</label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList runat="server" ClientIDMode="Static" ID="ddlTransfer" onchange="onFilterTypeChange(this)">
                                <asp:ListItem Value="1" Text="Revenue"></asp:ListItem>
                                <asp:ListItem Value="2" Text="Collection"></asp:ListItem>
                                <asp:ListItem Value="4" Text="Panel Allocation"></asp:ListItem>
                                <asp:ListItem Value="3" Text="GRN Purchase/Return"></asp:ListItem>
                               <%--  <asp:ListItem Value="5" Text="Doctor Share"></asp:ListItem>
                                   
                                <asp:ListItem Value="6" Text="Stock Adjustment and Process"></asp:ListItem>--%>

                            </asp:DropDownList>
                        </div>


                        <div class="col-md-3">
                            
                            
                        </div>
                        <div class="col-md-5">
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>


        <div class="POuter_Box_Inventory transferType hidden">

            <div class="Purchaseheader">
                Revenue Type
            </div>


            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">


                        <div class="col-md-3">
                            <label class="pull-left">Transfer Type</label>
                            <b class="pull-right">:</b>

                        </div>


                        <div class="col-md-21">




                            <label>
                                <input type="radio" name="rdoDepartment" value="R" checked="checked" onclick="onFilterTypeChange(this)" />Revenue
                            </label>
                            <label>
                                <input type="radio" name="rdoDepartment" value="DR" onclick="onFilterTypeChange(this)" />Debit Note-Credit Note
                            </label>
                            <label>
                                <input type="radio" name="rdoDepartment" value="PA" onclick="onFilterTypeChange(this)" />Panel Allocation
                            </label>

                            <label>
                                <input type="radio" name="rdoDepartment" value="DS" onclick="onFilterTypeChange(this)" />Doctor Share
                            </label>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>


        <div class="POuter_Box_Inventory">

            <div class="Purchaseheader">
                Date Range
            </div>


            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">


                        <div class="col-md-3">
                            <label class="pull-left">From Date</label>
                            <b class="pull-right">:</b>

                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtFromDate" disabled="true" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" runat="server" TargetControlID="txtFromDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>

                        </div>


                        <div class="col-md-3">
                            <label class="pull-left">To Date</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox runat="server" ID="txtToDate" ClientIDMode="Static"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender2" runat="server" TargetControlID="txtToDate" Format="dd-MMM-yyyy"></cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <asp:Button id="btnBeforeTransfer" runat="server" Text="Before Transfer Report" OnClick="btnBeforeTransfer_Click"/>
                        </div>

                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>



        </div>







        <div class="POuter_Box_Inventory textCenter">

            <button type="button" disabled="true" class="save margin-top-on-btn" id="btnSave" onclick="saveTransfer(this)">Transfer </button>

        </div>

    </div>

    <script type="text/javascript">


        $(document).ready(function () {


            bindCentre(function () {
                var type = Number($('#ddlTransfer').val());
                
                var module = 'All';// $('input:[type=radio][name=rdoDepartment]:checked').val();
                var centreID = Number($('#ddlCentre').val());
                $('#lblCentreID').text(centreID);
                //  $(btnSave).attr('disabled', true);
                getLastTransferDate({ type: type, moduleName: module, centreID: centreID }, function () { });
            });
        });




        var onFilterTypeChange = function () {
            var type = Number($('#ddlTransfer').val());
            var module = $('input:[type=radio][name=rdoDepartment]:checked').val();

            //if (type == 1) {
            //    $('.transferType').removeClass('hidden');
            //}
            //else if (type == 2) {
            //    $('.transferType').addClass('hidden');
            //    module = 'All';
            //}

            module = 'All';


            var centreID = Number($('#ddlCentre').val());
            getLastTransferDate({ type: type, moduleName: module, centreID: centreID }, function () { });
        }


        var bindCentre = function (callback) {
            serverCall('ManualFinanceTransfer.aspx/BindCentre', {}, function (response) {
                ddlCentre = $('#ddlCentre');
               
                var DefaultCentre = '<%=Session["CentreID"].ToString() %>';
                ddlCentre.bindDropDown({ data: JSON.parse(response), valueField: 'CentreID', textField: 'CentreName', isSearchAble: false, selectedValue: DefaultCentre });
               
                callback(ddlCentre.val());
            });
        }



        var saveTransfer = function (el) {
            var type = Number($('#ddlTransfer').val());
            var module = 'All';// $('input:[type=radio][name=rdoDepartment]:checked').val();
            var centreID = Number($('#ddlCentre').val());
            getLastTransferDate({ type: type, moduleName: module, centreID: centreID }, function () { });
            var data =
                {
                    type: Number($('#ddlTransfer').val()),
                    module: 'All', //$.trim($('input:[type=radio][name=rdoDepartment]:checked').val()),
                    fromDate: $.trim($('#txtFromDate').val()),
                    toDate: $.trim($('#txtToDate').val()),
                    centreID: Number($('#ddlCentre').val())
                };



            if (data.type == 0) {
                modelAlert('Please Select Type.');
                return false;
            }



            if (data.module == 0) {
                modelAlert('Please Select Module.');
                return false;
            }


            if (data.centreID == 0) {
                modelAlert('Please Select Centre.');
                return false;
            }

            if (data.toDate == '') {
                modelAlert('Please Select To Date.');
                return false;

            }



            if (data.fromDate == '') {
                modelAlert('Please Select From Date.');
                return false;
            }
            modelConfirmation('Data Transfer', 'Do you please confirm, if you want to process to transfer data from HIS to Finance.', 'YES', 'NO', function (response) {
                if (response) {
                    $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
                    $(btnSave).attr('disabled', true).val('Submitting...');
                    serverCall('ManualFinanceTransfer.aspx/TransferData', data, function (response) {
                        var responseData = JSON.parse(response);
                        modelAlert(responseData.response, function () {
                            if (responseData.status)
                                window.location.reload();
                            else
                                $(btnSave).removeAttr('disabled').val('Save');
                        });
                    });
                    $.unblockUI();
                }
                $.unblockUI();
                return false;
            });

        }


        var getLastTransferDate = function (data, callback) {

            console.log(data);

            serverCall('ManualFinanceTransfer.aspx/GetLastTransferDate', data, function (response) {
                var responseData = JSON.parse(response);
                $('#txtFromDate').val(responseData.lastDate).attr('disabled', !responseData.isFirstTimeTransfer);
                if (!responseData.status) {
                    modelAlert(responseData.response);
                    $('#btnSave').attr('disabled', true);
                }
                else {
                    $('#btnSave').attr('disabled', false);
                }


                callback(responseData);
            });
        }

        var BeforeTransfer = function () {
            var type = Number($('#ddlTransfer').val());
            var module = 'All';// $('input:[type=radio][name=rdoDepartment]:checked').val();
            var centreID = Number($('#ddlCentre').val());
            getLastTransferDate({ type: type, moduleName: module, centreID: centreID }, function () { });
            var data =
                {
                    type: Number($('#ddlTransfer').val()),
                    module: 'All', //$.trim($('input:[type=radio][name=rdoDepartment]:checked').val()),
                    fromDate: $.trim($('#txtFromDate').val()),
                    toDate: $.trim($('#txtToDate').val()),
                    centreID: Number($('#ddlCentre').val())
                };



            if (data.type == 0) {
                modelAlert('Please Select Type.');
                return false;
            }



            if (data.module == 0) {
                modelAlert('Please Select Module.');
                return false;
            }


            if (data.centreID == 0) {
                modelAlert('Please Select Centre.');
                return false;
            }

            if (data.toDate == '') {
                modelAlert('Please Select To Date.');
                return false;

            }



            if (data.fromDate == '') {
                modelAlert('Please Select From Date.');
                return false;
            }

            $.blockUI({ message: '<h3><img src="../../Images/loadingAnim.gif" /><br/>Just a moment...</h3>' });
            $(btnSave).attr('disabled', true).val('Submitting...');
            serverCall('ManualFinanceTransfer.aspx/BeforeTransferReport', data, function (response) {
                var responseData = JSON.parse(response);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        window.location.reload();
                    else
                        $(btnSave).removeAttr('disabled').val('Save');
                });
            });
            $.unblockUI();

        }







    </script>




</asp:Content>

