<%@ Page Language="C#" AutoEventWireup="true" CodeFile="PatientWiseSMS.aspx.cs" Inherits="Design_SMS_PatientWiseSMS" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">


<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <link href="../../Styles/framestyle.css" rel="stylesheet" type="text/css" />

</head>
<body>
    <%: System.Web.Optimization.Scripts.Render("~/bundle/folderinjs") %>
    <%: System.Web.Optimization.Styles.Render("~/bundle/folderincss") %>
    <script src="../../Scripts/Message.js" type="text/javascript"></script>
    <script src="../../Scripts/jquery-1.7.1.min.js" type="text/javascript"></script>
    <script type="text/javascript">

        var characterLimit = 120;
        $(document).ready(function () {
            bindSMSList(function () { });

            bindEmailList(function () { });
            hideShowdivothermobile();
            hideShowdivotherEmail();
            IsSmsOrEmail();
            $("#lblremaingCharacters").html(characterLimit);
            $("#<%=txtMessage.ClientID %>").bind("keyup", function () {
                var characterInserted = $(this).val().length;
                if (characterInserted > characterLimit) {
                    $(this).val($(this).val().substr(0, characterLimit));
                }
                var characterRemaining = characterLimit - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });
        });
        function bindSMSList() {

            serverCall('PatientWiseSMS.aspx/bindPatientSMSList', { TID: '<%=Request.QueryString["TID"]%>' }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    smslist(responseData.response)
                };
            });

        }
        function smslist(data) {

            $('#tbSMSList tbody').empty();
            for (var i = 0; i < data.length > 0; i++) {
                var row = '<tr>';
                var j = $('#tbSMSList tbody tr').length + 1;
                row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdMobile" class="GridViewLabItemStyle checked" style="text-align:center;">' + data[i].Mobile_No + '</td>';
                row += '<td id="tdText" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].SMS_Text + '</td>';
                row += '<td id="tdType" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].type + '</td>';
                row += '<td id="tdSendBy" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].SendBy + '</td>';
                row += '<td id="tdSendDate" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].SendDate + '</td>';
                row += '<td id="tdStatus" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].STATUS + '</td>';
                row += '<td id="tdDeliveryDate" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].DeliveryDate + '</td>';
                row += '</tr>';
                $('#tbSMSList tbody').append(row);
            }
            $('#divList').show();
        }
        function Save(btn) {
            button.Attributes.Add("AutoPostback", "true");
            if ($("#<%=txtMessage.ClientID %>").val() == '') {
                modelAlert('Please enter a text for sms');
                $("#<%=txtMessage.ClientID %>").focus();
                return false;
            }

            else {
                $("#<%=lblMsg.ClientID %>").text('');

            }
            btn.disabled = true;
            btn.value = 'Submitting...';

            __doPostBack('btnSave', '');

        }

        function SaveEmail(btn) {
            button.Attributes.Add("AutoPostback", "true");
            if ($("#<%=txtEmailBody.ClientID %>").val() == '') {
                modelAlert('Please enter a Body for Email');
                $("#<%=txtEmailBody.ClientID %>").focus();
                return false;
            }
            if ($("#<%=txtEmailSubject.ClientID %>").val() == '') {
                modelAlert('Please enter a Body for Email');
                $("#<%=txtEmailSubject.ClientID %>").focus();
                return false;
            }
            else {
                $("#<%=lblEmailError.ClientID %>").text('');

            }
            if ($("#<%=lblPatientEmail.ClientID %>").val() == '') {
                var isChecked = $('#chkAlternatEmail').is(":checked");

                if (isChecked) {
                    if ($("#<%=txtOtherEmail.ClientID %>").val() == '') {
                        modelAlert('Please Enter Email ID');
                        $("#<%=txtOtherEmail.ClientID %>").focus();
                         return false;
                    }
                } else {
                    modelAlert('Please Enter Email ID');
                    $("#<%=txtEmailSubject.ClientID %>").focus();
                      return false;
                }

            }



            btn.disabled = true;
            btn.value = 'Submitting...';

            __doPostBack('btnEmailSave', '');

        }


    </script>


    <form id="form1" runat="server">
        <div id="Pbody_box_inventory">
            <div class="POuter_Box_Inventory">
                <div class="content" style="text-align: center;">
                    <asp:RadioButtonList runat="server" ID="rblSelectType" ClientIDMode="Static" onclick="IsSmsOrEmail()" RepeatDirection="Horizontal" RepeatColumns="5" style="text-align: center;margin-left: 520px;">
                        <asp:ListItem Text="SMS" Value="0" Selected="True"></asp:ListItem>
                        <asp:ListItem Text="Email" Value="1"></asp:ListItem>

                    </asp:RadioButtonList>
                </div>


            </div>

            <div class="POuter_Box_Inventory divSms" style="display: none">

                <div class="content" style="text-align: center;">
                    <b>Send Message to Patient</b>
                    <br />
                    <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>




            </div>
            <div class="POuter_Box_Inventory divSms" style="display: none">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Patient Mobile</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPatientMobile" runat="server" Font-Bold="true"></asp:Label>
                    </div>
                    <div class="col-md-4">
                        <asp:CheckBox ID="chkIsOtherMobileNumber" runat="server" Text="Alternate Mobile No" ClientIDMode="Static" onclick="hideShowdivothermobile()" />
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" id="divothermobile">
                        <asp:TextBox runat="server" ID="txtOtherMobileNo" TextMode="Number" ClientIDMode="Static"></asp:TextBox>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            SMS Text
                        </label>
                        <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-21">
                        <asp:TextBox ID="txtMessage" ClientIDMode="Static" CssClass="requiredField" runat="server" Height="79px" TextMode="MultiLine"></asp:TextBox>
                        Number of Characters Left:
                        <label id="lblremaingCharacters" style="background-color: #E2EEF1; color: Red; font-weight: bold;">
                        </label>
                    </div>
                </div>

                <div class="POuter_Box_Inventory" style="text-align: center;">

                    <asp:Button ID="btnSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Save" OnClick="btnSave_Click" OnClientClick="return Save(this);" ValidationGroup="save" ToolTip="Click to save SMS text" />
                </div>
                <div class="POuter_Box_Inventory">

                    <div id="divList" style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" id="tbSMSList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 20px;">Mobile</th>
                                    <th class="GridViewHeaderStyle" style="width: 200px;">Text</th>
                                    <th class="GridViewHeaderStyle" style="width: 20px;">PatientType</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px;">Send By</th>
                                    <th class="GridViewHeaderStyle" style="width: 60px;">Send Date</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">Status</th>
                                    <th class="GridViewHeaderStyle" style="width: 60px;">DeliveryDate</th>

                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            </div>



            <div class="POuter_Box_Inventory divEmail" style="display: none">

                <div class="content" style="text-align: center;">
                    <b>Send Email to Patient</b>
                    <br />
                    <asp:Label ID="lblEmailError" runat="server" CssClass="ItDoseLblError"></asp:Label>
                </div>




            </div>
            <div class="POuter_Box_Inventory  divEmail" style="display: none">
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">Patient Email</label>
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:Label ID="lblPatientEmail" runat="server" Font-Bold="true"></asp:Label>
                    </div>
                    <div class="col-md-4">
                        <asp:CheckBox ID="chkAlternatEmail" runat="server" Text="Alternate Email" ClientIDMode="Static" onclick="hideShowdivotherEmail()" />
                        <b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5" id="divOtherEmail">
                        <asp:TextBox runat="server" ID="txtOtherEmail" ClientIDMode="Static" TextMode="Email"></asp:TextBox>
                    </div>

                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Email Subject
                        </label>
                        <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-21">
                        <asp:TextBox ID="txtEmailSubject" ClientIDMode="Static" CssClass="requiredField" runat="server" Height="40px" TextMode="MultiLine"></asp:TextBox>

                    </div>
                </div>
                <div class="row">
                    <div class="col-md-3">
                        <label class="pull-left">
                            Email Body
                        </label>
                        <b class="pull-right">:</b>
                    </div>

                    <div class="col-md-21">
                        <asp:TextBox ID="txtEmailBody" ClientIDMode="Static" CssClass="requiredField" runat="server" Height="80px" TextMode="MultiLine"></asp:TextBox>

                    </div>
                </div>
 </div>

                <div class="POuter_Box_Inventory divEmail" style="text-align: center;">

                    <asp:Button ID="btnEmailSave" runat="server" ClientIDMode="Static" CssClass="ItDoseButton" Text="Save" OnClick="btnEmailSave_Click" OnClientClick="return SaveEmail(this);" ValidationGroup="save" ToolTip="Click to save Email text" />
                </div>
                <div class="POuter_Box_Inventory divEmail">

                    <div id="divEmailTable" style="max-height: 400px; overflow-x: auto">
                        <table class="FixedHeader" id="tblEmailList" cellspacing="0" rules="all" border="1" style="width: 100%; border-collapse: collapse">
                            <thead>
                                <tr>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">SrNo</th>
                                    <th class="GridViewHeaderStyle" style="width: 20px;">To Email</th>
                                    <th class="GridViewHeaderStyle" style="width: 200px;">Subject</th>
                                    <th class="GridViewHeaderStyle" style="width: 200px;">Body</th>
                                    <th class="GridViewHeaderStyle" style="width: 20px;">PatientType</th>
                                    <th class="GridViewHeaderStyle" style="width: 50px;">Send By</th>
                                    <th class="GridViewHeaderStyle" style="width: 60px;">Send Date</th>
                                    <th class="GridViewHeaderStyle" style="width: 30px;">Status</th>
                                    <th class="GridViewHeaderStyle" style="width: 60px;">DeliveryDate</th>

                                </tr>
                            </thead>
                            <tbody></tbody>
                        </table>
                    </div>
                </div>
            

        </div>

    </form>

    <script type="text/javascript">

        function hideShowdivothermobile() {
            var isChecked = $('#chkIsOtherMobileNumber').is(":checked");

            if (isChecked) {
                $("#divothermobile").show();
            } else {
                $("#divothermobile").hide();
                $("#txtOtherMobileNo").val("");
            }
        }
        
        function hideShowdivotherEmail() {
            var isChecked = $('#chkAlternatEmail').is(":checked");

            if (isChecked) {
                $("#divOtherEmail").show();
            } else {
                $("#divOtherEmail").hide();
                $("#txtOtherEmail").val("");
            }
        }


        function IsSmsOrEmail() {

            var type = $('#<%=rblSelectType.ClientID %> input:checked').val()

            if (type == 1) {
                $(".divSms").hide();
                $(".divEmail").show();
            } else {
                $(".divEmail").hide();
                $(".divSms").show();
            }

        }





        function bindEmailList() {

            serverCall('PatientWiseSMS.aspx/bindPatientEmailList', { TID: '<%=Request.QueryString["TID"]%>' }, function (response) {
                var responseData = JSON.parse(response);
                if (responseData.status) {
                    Emaillist(responseData.response)
                };
            });

        }
        function Emaillist(data) {

            $('#tblEmailList tbody').empty();
            for (var i = 0; i < data.length > 0; i++) {
                var row = '<tr>';
                var j = $('#tblEmailList tbody tr').length + 1;
                row += '<td class="GridViewLabItemStyle checked" style="text-align: center;">' + j + '</td>';
                row += '<td id="tdEmail" class="GridViewLabItemStyle checked" style="text-align:center;">' + data[i].Email + '</td>';
                row += '<td id="tdEmailSubject" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].EmailSubject + '</td>';
                row += '<td id="tdEmailBody" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].EmailBody + '</td>';

                row += '<td id="tdType" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].type + '</td>';
                row += '<td id="tdSendBy" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].SendBy + '</td>';
                row += '<td id="tdSendDate" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].SendDate + '</td>';
                row += '<td id="tdStatus" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].STATUS + '</td>';
                row += '<td id="tdDeliveryDate" class="GridViewLabItemStyle checked" style="text-align: center;">' + data[i].DeliveryDate + '</td>';
                row += '</tr>';
                $('#tblEmailList tbody').append(row);
            }
            $('#divEmailTable').show();
        }









    </script>
</body>
</html>
