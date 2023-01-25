<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="CountryMaster.aspx.cs" Inherits="Design_EDP_CountryMaster" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        function check(con) {
            if (($.trim($("#txtCountryName").val()) == "") && (con == "1")) {
                DisplayMsg('MM154', 'lblMsg');
                $("#txtCountryName").focus();
                return false;
            }
            if (($("#ddlCountry option:selected").text() == "Select") && (con == "2")) {
                $("#lblMsg").text('Please Select Country');
                $("#ddlCountry").focus();
                return false;
            }

            if ($.trim($("#txtCurrency").val()) == "") {
                DisplayMsg('MM155', 'lblMsg');
                $("#txtCurrency").focus();
                return false;
            }
            if ($.trim($("#txtNotation").val()) == "") {
                DisplayMsg('MM158', 'lblMsg');
                $("#txtNotation").focus();
                return false;
            }
            if ($.trim($("#txtCounsellorAddress").val()) == "") {
                DisplayMsg('MM156', 'lblMsg');
                $("#txtCounsellorAddress").focus();
                return false;
            }
            if ($.trim($("#txtAddressEmbassy").val()) == "") {
                DisplayMsg('MM157', 'lblMsg');
                $("#txtAddressEmbassy").focus();
                return false;

            }
            if (con == "1") {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }

            else {
                document.getElementById('<%=btnUpdate.ClientID%>').disabled = true;
                document.getElementById('<%=btnUpdate.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnUpdate', '');
            }
        }
        $(document).ready(function () {
            var MaxLength = 200;
            $("#txtCounsellorAddress,#txtAddressEmbassy").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
            $("#txtCounsellorAddress,#txtAddressEmbassy").bind("keypress", function (e) {
                if (window.event) {
                    keynum = e.keyCode
                }
                else if (e.which) {
                    keynum = e.which
                }
                keychar = String.fromCharCode(keynum)
                if (e.keyCode == 39 || keychar == "'") {
                    return false;
                }
                if ($(this).val().length >= MaxLength) {

                    if (window.event)//IE
                    {
                        e.returnValue = false;
                        return false;
                    }
                    else//Firefox
                    {
                        e.preventDefault();
                        return false;
                    }
                }
            });
        });

    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="sc" runat="server"></Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Country Master</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
        </div>

        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-8">
                            <asp:RadioButtonList ID="rdoEdit" runat="server" RepeatDirection="Horizontal" AutoPostBack="True"
                                OnSelectedIndexChanged="rdoEdit_SelectedIndexChanged"
                                ToolTip="Select Add Or Edit To Update Country">
                                <asp:ListItem Selected="True" Value="1">Add</asp:ListItem>
                                <asp:ListItem Value="2">Edit</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Country Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCountryName" runat="server" Width="95%" ClientIDMode="Static"
                                ToolTip="Enter Country Name"></asp:TextBox>
                            <asp:Label ID="Label3" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                            <asp:DropDownList ID="ddlCountry" ClientIDMode="Static" runat="server" OnSelectedIndexChanged="ddlCountry_SelectedIndexChanged"
                                Visible="False" AutoPostBack="True" ToolTip="Select Country Name">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Currency
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCurrency" Width="95%" runat="server" ToolTip="Enter Currency  Name" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="Label5" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Notation
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtNotation" runat="server" Width="95%" ToolTip="Enter Notation" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="Label4" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rdoIsActive" runat="server" RepeatDirection="Horizontal"
                                ToolTip="Select Active 0r In-Active To Update Country ">
                                <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                                <asp:ListItem Value="0">DeActive</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5">
                            <asp:CheckBox ID="ChkIsBaseCurrency" runat="server" Style="color: #800000"
                                Text="IsBaseCurrency" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                        </div>
                        <div class="col-md-5">
                            <strong>Counsellor Details</strong>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5">
                            <strong>Embassy Details</strong>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>

                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCounsellorAddress" runat="server" Height="70px"
                                Width="95%" TextMode="MultiLine" ToolTip="Enter Co unsellor Name" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="Label6" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Address
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtAddressEmbassy" runat="server" Height="70px" Width="95%"
                                TextMode="MultiLine" ToolTip="Enter Embassy Name" ClientIDMode="Static"></asp:TextBox>
                            <asp:Label ID="Label7" runat="server" Style="color: Red; font-size: 10px;">*</asp:Label>
                        </div>

                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Phone No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPhoneNoCounsellor" runat="server"
                                ToolTip="Enter Counsellor Phone No." MaxLength="15"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbPhoneNoCounsellor" runat="server" FilterType="Numbers" TargetControlID="txtPhoneNoCounsellor"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Phone No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPhoneNoEmbassy" runat="server"
                                ToolTip="Enter Embassy Phone No." MaxLength="15"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="ftbPhoneNoEmbassy" runat="server" FilterType="Numbers" TargetControlID="txtPhoneNoEmbassy"></cc1:FilteredTextBoxExtender>

                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Fax No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFaxNoCounsellor" runat="server"
                                ToolTip="Enter Counsellor Fax No."></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Fax No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtFaxNoEmbassy" runat="server"
                                ToolTip="Enter Fax No."></asp:TextBox>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <asp:Button ID="btnSave" runat="server" Text="Save" OnClick="btnSave_Click"
                ToolTip="Click To Save " CssClass="ItDoseButton" OnClientClick="return check(1);" />
            <asp:Button ID="btnUpdate" runat="server" Text="Update" Visible="False"
                OnClick="btnUpdate_Click" ToolTip="Click To Update" CssClass="ItDoseButton" OnClientClick="return check(2);" />
        </div>
    </div>
</asp:Content>
