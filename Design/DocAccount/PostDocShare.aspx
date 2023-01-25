<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="PostDocShare.aspx.cs" Inherits="Design_DocAccount_PostDocShare" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35" Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory">
            <div style="text-align: center;">
                <b>Post Doctor Share </b>
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor Share Details
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblFromDate" Font-Bold="true" runat="server" ClientIDMode="Static"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:Label ID="lblToDate" runat="server" Font-Bold="true" ClientIDMode="Static"></asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Doctor
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlDoctor" runat="server" ToolTip="Select Doctor" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                    </div>

                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" style="text-align: center;">
            <input type="button" class="ItDoseButton" id="btnPost" value="Post Doctor Share" title="Click to Post Doctor Share" onclick="postDoctorShare(this);" />
        </div>
    </div>
    <script type="text/javascript">

        $(document).ready(function () {
            getDate();
        });

        function getDate() {
            $.ajax({
                url: "Services/DocAccount.asmx/BindDetail",
                data: '{}',
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                cache: false,
                success: function (result) {
                    DocData = result.d;
                    if (DocData != "") {
                        $("#lblFromDate").text(DocData.split('#')[0]);
                        $("#lblToDate").text(DocData.split('#')[1]);
                        $('#btnSearch').attr('disabled', false);
                    }
                    else {
                        $("#lblmsg").text('Please Set Doctor Share Date');
                        $("#lblFromDate,#lblToDate").text('');
                        $('#btnSearch').attr('disabled', true);
                    }
                },
                error: function (xhr, status) {
                    var err = eval("(" + xhr.responseText + ")");
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function ChkDate() {
            $.ajax({
                url: "CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $("#lblFromDate").text() + '",DateTo:"' + $("#lblToDate").text() + '"}',
                type: "POST",
                async: false,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $("#lblmsg").text('To date can not be less than from date!');
                        getDate();
                    }
                    else {
                        $("#lblmsg").text('');
                    }
                }
            });
        }

        var postDoctorShare = function (btnSave) {

            if ($("#ddlDoctor option:selected").text() == "--No Data--")
            {
                $("#lblmsg").text('There are No doctor available for posting the doctor share!');
                return false;
            }
            $(btnSave).attr('disabled', true).val('Submitting...');

            data = {
                isPost: 1,
                FromDate: $('#lblFromDate').text(),
                ToDate: $('#lblToDate').text(),
                DoctorID: Number($("#ddlDoctor").val())
            }
            serverCall('Services/DocAccount.asmx/PostDoctorShareNew', data, function (resposne) {
                var responseData = JSON.parse(resposne);
                modelAlert(responseData.response, function () {
                    if (responseData.status)
                        window.location.reload();
                    else
                        $(btnSave).removeAttr('disabled').val('Post Doctor Share');
                });
            });
        }
    </script>
</asp:Content>
