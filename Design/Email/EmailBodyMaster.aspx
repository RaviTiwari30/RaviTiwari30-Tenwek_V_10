<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="EmailBodyMaster.aspx.cs" Inherits="Design_Email_EmailBodyMaster" %>

<%@ Register TagPrefix="CE" Namespace="CuteEditor" Assembly="CuteEditor" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory">
            <div style="text-align: center">
                <b>Manage Email Body Master</b>&nbsp;<br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
                <asp:Label ID="lblID" runat="server" style="display:none" ClientIDMode="Static"></asp:Label>
            </div>
        </div>
        <div>
            <div class="POuter_Box_Inventory">
                <div class="row">
                    <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Department</label><b class="pull-right">:</b></div>
                        <div class="col-md-5"> <asp:DropDownList ID="ddlDepartment" runat="server"  ClientIDMode="Static"
                                CssClass="requiredField searchable" >
                            </asp:DropDownList> </div>
                        <div class="col-md-3"><label class="pull-left">Template Type</label><b class="pull-right">:</b></div>
                            <div class="col-md-5"><asp:DropDownList ID="ddlTemplatetype" runat="server"  ClientIDMode="Static"
                                CssClass="requiredField searchable" AutoPostBack="True" OnSelectedIndexChanged="ddlTemplatetype_SelectedIndexChanged">
                            </asp:DropDownList></div>
                            <div class="col-md-3">
                                <asp:Label ID="lblEventTime" runat="server" Visible="false" ></asp:Label>
                            <asp:Label ID="lblEventDate" runat="server"  Visible="false"></asp:Label>
                            <asp:Label ID="lblTemplatetype" runat="server"  Visible="false"></asp:Label>
                                <asp:Label ID="lblEmail_repeat" runat="server"  Visible="false"></asp:Label>
                                <label class="pull-left">From Email</label><b class="pull-right">:</b>
                            </div>
                            <div class="col-md-5">
                                <asp:DropDownList ID="ddlEmailID" runat="server" CssClass="requiredField searchable"></asp:DropDownList>
                                <asp:TextBox ID="txtPassword"  runat="server" Width="200px" ClientIDMode="Static" Visible="false"></asp:TextBox>
                            </div>
                    </div>
                    <div class="row" style="display:none">
                        <div class="col-md-3">
                            <label class="pull-left">Email SMTP</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmailSMTP" runat="server" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3"><label class="pull-left">Email Port</label><b class="pull-right">:</b> </div>
                        <div class="col-md-5"><asp:TextBox ID="txtPort" runat="server" TextMode="Number" ClientIDMode="Static"></asp:TextBox></div>
                        <div class="col-md-3"><label class="pull-left"> </label></div>
                        <div class="col-md-5"></div>
                    </div>
                    <div class="row">
                    <div class="col-md-3"><label class="pull-left">Email Subject</label><b class="pull-right">:</b></div>
                    <div class="col-md-13"><asp:TextBox ID="txtEmailSubject" runat="server" Width="100%" ClientIDMode="Static" AutoCompleteType="Disabled" CssClass="requiredField" ></asp:TextBox></div>
                    <div class="col-md-3">
                          <label class="pull-left">Error Notify Email</label><b class="pull-right">:</b>
                    </div>
                    <div class="col-md-5">
                        <asp:DropDownList runat="server" ID="ddlPanel" ClientIDMode="Static" Visible="false" CssClass="searchable"></asp:DropDownList>
                        <asp:TextBox ID="txtErrorEmail" runat="server" TextMode="Email" ClientIDMode="Static" AutoCompleteType="Disabled" Width="226px"></asp:TextBox>
                    </div>
                    </div>

                </div><div class="col-md-1"></div></div>
            </div>
            <div class="POuter_Box_Inventory">
                <div class="Purchaseheader">
                    Email Body
                </div>
                <table border="0" cellpadding="0" cellspacing="0" style="width: 100%">
                    <tr>
                        <td align="center" class="ItDoseLabel" style="width: 80%;" valign="top">
                            <ckeditor:ckeditorcontrol ID="txtEmailBody" BasePath="~/ckeditor" runat="server"  ClientIDMode="Static"  EnterMode="BR"></ckeditor:ckeditorcontrol>
                        </td>
                        <td align="left" valign="top">
                            <strong>&nbsp;Column Field:</strong><br />
                            <div style="width:100%;height:323px;overflow-y:scroll">
                            <asp:CheckBoxList ID="chkCloumnField" runat="server" AutoPostBack="true" OnSelectedIndexChanged="chkCloumnField_SelectedIndexChanged" >
                                <asp:ListItem Value="PatientName">PatientName</asp:ListItem>
                                <asp:ListItem Value="MRNo">PatientID</asp:ListItem>
                                <asp:ListItem Value="AppNo">AppNo</asp:ListItem>
                                <asp:ListItem Value="Age">Age</asp:ListItem>
                                <asp:ListItem Value="TransactionID">TransactionID</asp:ListItem>
                                <asp:ListItem Value="LedgertransactionNo">LedgertransactionNo</asp:ListItem>
                                <asp:ListItem Value="DoctorID">DoctorID</asp:ListItem>
                                <asp:ListItem Value="DoctorName">DoctorName</asp:ListItem>
                                <asp:ListItem Value="TemplateID">TemplateID</asp:ListItem>
                                <asp:ListItem Value="Title">Title</asp:ListItem>
                              <%--  <asp:ListItem Value="AppDate">AppDate</asp:ListItem>--%>
                                <asp:ListItem Value="InvestigationName">InvestigationName   </asp:ListItem>
                                <asp:ListItem Value="FromDepartment">FromDepartment</asp:ListItem>
                                <asp:ListItem Value="ErrorType">ErrorType</asp:ListItem>
                                <asp:ListItem Value="Priority">Priority</asp:ListItem>
                                <asp:ListItem Value="RoomNo">RoomNo</asp:ListItem>
                                <asp:ListItem Value="BedNo">BedNo</asp:ListItem>
                                <asp:ListItem Value="PanelName">PanelName</asp:ListItem>
                                <asp:ListItem Value="EmployeeName">EmployeeName</asp:ListItem>
                                <asp:ListItem Value="UserName">UserName</asp:ListItem>
                                <asp:ListItem Value="Passsword">Passsword</asp:ListItem>
                                <asp:ListItem Value="RoomType">RoomType</asp:ListItem>
                                <asp:ListItem Value="Date">Date</asp:ListItem>
                                <asp:ListItem Value="FromDate">FromDate</asp:ListItem>
                                <asp:ListItem Value="ToDate">ToDate</asp:ListItem>
                                <asp:ListItem Value="BillNo">BillNo</asp:ListItem>
                                <asp:ListItem Value="ReceiptNo">ReceiptNo</asp:ListItem>
                                <asp:ListItem Value="BillAmount">BillAmount</asp:ListItem>
                                <asp:ListItem Value="BalanceAmount">BalanceAmount</asp:ListItem>
                                <asp:ListItem Value="PaidAmount">PaidAmount</asp:ListItem>
                                <asp:ListItem Value="IPNo">IPNo</asp:ListItem>
                                <asp:ListItem Value="Discount">Discount</asp:ListItem>
                                <asp:ListItem Value="ApprovalAmount">ApprovalAmount</asp:ListItem>
                                <asp:ListItem Value="NICNumber">NIC Number</asp:ListItem>
                                <asp:ListItem Value="PolicyNumber">Policy Number</asp:ListItem>
                                <asp:ListItem Value="PolicyCardNumber">Policy Card Number</asp:ListItem>
                                <asp:ListItem Value="PolicyExpiryDate">Policy Expiry Date</asp:ListItem>
                                <asp:ListItem Value="AppointmentDate">Appointment Date</asp:ListItem>
                                <asp:ListItem Value="AppointmentTime">Appointment Time</asp:ListItem>
                                <asp:ListItem Value="EmailAddress">EmailAddress</asp:ListItem>
                                <asp:ListItem Value="AdmissionDate">AdmissionDate</asp:ListItem>
                            </asp:CheckBoxList></div>
                        </td>
                    </tr>
                </table>
                 <div class="Purchaseheader">
                    Store Procedure
                </div>
                <table style="width:100%">
                    <tr>
                        <td style="width:25%;text-align:right">Store Procedure Name :</td><td><asp:TextBox ID="txtStoreProcedureName" AutoCompleteType="Disabled" ClientIDMode="Static" runat="server" Width="70%"></asp:TextBox></td>
                    </tr>
                </table>
                <table style="width:100%">
                    
                    <tr>
                        <td style="width:100%" colspan="3">
                            <asp:TextBox ID="txtStoreProcedure"  runat="server" TextMode="MultiLine" Height="50px" Width="100%" ClientIDMode="Static" AutoCompleteType="Disabled"></asp:TextBox>
                        </td>
                        <td></td>
                        <td></td><td></td>
                    </tr>
                   
                    
                </table>
                <table style="width:100%">
                     <tr>
                        <td style="width:20%;text-align:right">
                          Attachement Type :&nbsp;
                        </td>
                        <td style="width:20%"> <asp:DropDownList ID="ddlAttachementtype" runat="server" ClientIDMode="Static" Width="200px">
                            <asp:ListItem Value="0">Select</asp:ListItem>
                            <asp:ListItem Value="P">PDF</asp:ListItem>
                            <asp:ListItem Value="E">Excel</asp:ListItem>
                            <asp:ListItem Value="H">Html Table</asp:ListItem>
                             </asp:DropDownList></td>
                        <td style="width:20%;text-align:right">Report Path :&nbsp;</td><td style="width:20%"><asp:TextBox ID="txtReportPath" runat="server" Width="200px" AutoCompleteType="Disabled"></asp:TextBox></td>
                         <td style="width:20%"><asp:CheckBox ID="chkcentreheader" runat="server" Text="Include Centre Header" /></td>
                    </tr>
                </table>
                
            </div>
        </div>
        <div style="text-align:center" class="POuter_Box_Inventory">
                    <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" Text="Save" Width="56px" CssClass="ItDoseButton" OnClientClick="return Validation()" />
                </div>
    </div>
    <script type="text/javascript">
        function Validation() {
            if($('#ddlDepartment').val() == "0")
            {
                $('#lblMsg').text('Please Select the Department');
                $('#ddlDepartment').focus();
                return false;
            }
            if ($('#ddlTemplatetype').val() == "0") {
                $('#lblMsg').text('Please Select Template');
                $('#ddlTemplatetype').focus();
                return false;
            }
            if ($('#txtFromEmail').val() == "") {
                $('#lblMsg').text('Please Enter Email ID');
                $('#txtFromEmail').focus();
                return false;
            }
            var emailaddress = jQuery.trim(jQuery('#txtFromEmail').val());
            var emailexp = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if ((emailexp.test(emailaddress) == false) && (emailaddress != "")) {
                jQuery('#lblMsg').text('Please Enter Valid Email Address');
                jQuery('#txtFromEmail').focus();
                return false;
            }
            if ($('#txtPassword').val() == "") {
                $('#lblMsg').text('Please Enter Password');
                $('#txtPassword').focus();
                return false;
            }
            if ($('#txtEmailSubject').val() == "") {
                $('#lblMsg').text('Please Enter Email Subject');
                $('#txtEmailSubject').focus();
                return false;
            }
            //if ($('#txtEmailBody').val() == "") {
            //    $('#lblMsg').text('Please Enter the Email Body');
            //    $('#txtEmailBody').focus();
            //    return false;
            //}
            if ($('#txtStoreProcedure').val() != "") {
                if ($('#txtStoreProcedureName').val() == "") {
                    $('#lblMsg').text('Please Enter the Store Procedure Name');
                    $('#txtEmailBody').focus();
                    return false;
                }
                if ($('#ddlAttachementtype').val() == "0")
                {
                    $('#lblMsg').text('Please Select the attachement type');
                    $('#ddlAttachementtype').focus();
                    return false;
                }
            }
            return true;
        }
        $(function () {
            $('.searchable').chosen();
        });
    </script>
    </asp:Content>
