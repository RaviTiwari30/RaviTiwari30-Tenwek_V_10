<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SubCategoryMaster.aspx.cs"
    Inherits="Design_EDP_SubCategoryMaster" MasterPageFile="~/DefaultHome.master"
    EnableEventValidation="false" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="DropDownCheckBoxes" Namespace="Saplin.Controls" TagPrefix="asp" %>

<asp:Content ContentPlaceHolderID="ContentPlaceHolder1" ID="Content1" runat="server">
    <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">

        $(document).ready(function () {
            var rb = $('[id$=rbisAsset] input:checked').val();

            if (rb == "YES") {
                $('[id$=divdepart]').css("display", "");
                $('[id$=divddlDept]').css("display", "");
            }
            else if (rb == "NO") {
                $('[id$=divdepart]').css("display", "none");
                $('[id$=divddlDept]').css("display", "none");

            }
        });

        function AssetChangeEvent() {
            var rb = $('[id$=rbisAsset] input:checked').val();

            if (rb == "YES") {
                $('[id$=divdepart]').css("display", "");
                $('[id$=divddlDept]').css("display", "");
            }
            else if (rb == "NO") {
                $('[id$=divdepart]').css("display", "none");
                $('[id$=divddlDept]').css("display", "none");

            }
        }

        var _oldColor;
        function SetNewColor(source) {
            _oldColor = source.style.backgroundColor;
            source.style.backgroundColor = '#387C44';
        }

        function SetOldColor(source) {
            source.style.backgroundColor = _oldColor;
        }
        function ShowPO(PONo) {
            window.open(PONo);
        }

        function RestrictDoubleEntry() {
            if ($.trim($("#<%=txtName.ClientID%>").val()) == "") {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Sub Category Name');
                $("#<%=txtName.ClientID%>").focus();
                return false;
            }
            if ($("#<%=ddlDisplayName.ClientID%>").val() == "0") {
                $("#<%=lblMsg.ClientID%>").text('Please Select Display Name');
                $("#<%=ddlDisplayName.ClientID%>").focus();
                return false;
            }
            if (($("#<%=ddlCategoryName.ClientID%>").val().split('#')[1] == "5") && ($.trim($("#txtValidityPeriod").val()) == "")) {
                $("#<%=lblMsg.ClientID%>").text('Please Enter Validity Period');
                $("#<%=txtValidityPeriod.ClientID%>").focus();
                return false;
            }
            document.getElementById('<%=btnSave.ClientID%>').disabled = true;
            document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');

        }
    </script>

    <style type="text/css">
        .requiredField1 {
            border-radius: 4px;
            width: 100%;
            height: 23px !important;
        }
    </style>

    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>SubCategory Master </b>
            <br />
            <asp:Label ID="lblMsg" CssClass="ItDoseLblError" runat="server"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">
                            <asp:RadioButtonList ID="rbtnStatus" runat="server" AutoPostBack="True" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged"
                                RepeatDirection="Horizontal" ToolTip="Select New Or Edit To Update SubCategory Master">
                                <asp:ListItem Selected="True">NEW</asp:ListItem>
                                <asp:ListItem>EDIT</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <asp:MultiView ID="MultiView1" runat="server">
            <asp:View ID="View1" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Create New SubCategory
                    </div>

                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlCategoryName" runat="server" AutoPostBack="True"
                                        OnSelectedIndexChanged="ddlCategoryName_SelectedIndexChanged" ToolTip="Select Category">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Sub Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtName" runat="server" MaxLength="50" CssClass="required" ToolTip="Enter SubCategory Name"></asp:TextBox>

                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Display Name
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlDisplayName" runat="server" CssClass="required"></asp:DropDownList>

                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Print Order No.
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtPrintOrder" runat="server" MaxLength="3" ToolTip="Enter Print Order No."></asp:TextBox>
                                    <cc1:FilteredTextBoxExtender ID="ftbOrder" runat="server" FilterType="Numbers" TargetControlID="txtPrintOrder"></cc1:FilteredTextBoxExtender>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Abbreviation
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox ID="txtAbbreviation" runat="server" MaxLength="4"></asp:TextBox>
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Active
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:RadioButtonList ID="rbtnActive" runat="server" RepeatDirection="Horizontal"
                                        ToolTip="Select Active Or In-Active To Update Sub-Category Master">
                                        <asp:ListItem Selected="True">YES</asp:ListItem>
                                        <asp:ListItem>NO</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                                <div class="col-md-3" id="divIsAsset" runat="server">
                                    <label class="pull-left">
                                        Is Asset
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5" id="divrbisAsset">
                                    <asp:RadioButtonList ID="rbisAsset" runat="server" RepeatDirection="Horizontal" onchange="AssetChangeEvent();"
                                        ToolTip="Select Active Or In-Active To Update Sub-Category Master">
                                        <asp:ListItem Selected="True" Value="YES">YES</asp:ListItem>
                                        <asp:ListItem Value="NO">NO</asp:ListItem>
                                    </asp:RadioButtonList>
                                </div>
                                <div class="col-md-3" id="divdepart" runat="server">
                                    <label class="pull-left">
                                        Department
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5" id="divddlDept" runat="server">
                                    <asp:DropDownCheckBoxes ID="ddlDept" runat="server" AddJQueryReference="True" UseButtons="false" UseSelectAllNode="True" Height="23px" CssClass="requiredField requiredField1">
                                        <Texts SelectBoxCaption="Select" />
                                    </asp:DropDownCheckBoxes>
                                </div>
                            </div>

                            <div style="display:none" id="divScaleOfCost" runat="server" class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Scale of Cost
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:TextBox  ID="txtScaleOfCost" onlynumber="8" decimalplace="6" max-value="100" runat="server"></asp:TextBox>
                                </div>



                            </div>

                        </div>
                        <div class="col-md-1"></div>
                    </div>
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td colspan="2" style="text-align: left">
                                <asp:CheckBox ID="chkScheduler" runat="server" Text="Does Affect Scheduler ?" Width="250px" />
                            </td>
                        </tr>

                        <tr id="trValidityPeriod" runat="server" visible="false">
                            <td style="width: 8%; text-align: left">Validity Period :&nbsp;</td>
                            <td style="width: 25%; text-align: left">
                                <asp:TextBox ID="txtValidityPeriod" runat="server" MaxLength="3" ClientIDMode="Static"></asp:TextBox>
                                <span style="color: red; font-size: 10px;" class="shat">*</span>
                                <em><span style="font-size: 7.5pt" class="ItDoseLabelSp">(In Days)</span></em>
                                <cc1:FilteredTextBoxExtender ID="ftbValidityPeriod" runat="server" TargetControlID="txtValidityPeriod" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                            </td>
                            <td style="width: 25%">&nbsp;</td>
                            <td style="width: 25%; text-align: left">&nbsp;</td>
                        </tr>

                    </table>

                </div>
                <div class="POuter_Box_Inventory textCenter">
                    <asp:UpdatePanel ID="uppanel" runat="server">
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnSave" EventName="click" />
                        </Triggers>
                        <ContentTemplate>
                            <asp:Button ID="btnSave" Text="Save" CssClass="save margin-top-on-btn" runat="server" OnClientClick="return RestrictDoubleEntry();" OnClick="btnSave_Click" TabIndex="13" ToolTip="Click to Save" />
                        </ContentTemplate>
                    </asp:UpdatePanel>
                    

                </div>
            </asp:View>
            <asp:View ID="View2" runat="server">
                <div class="POuter_Box_Inventory">
                    <div class="Purchaseheader">
                        Edit SubCategory
                    </div>
                    <div class="row">
                        <div class="col-md-1"></div>
                        <div class="col-md-22">
                            <div class="row">
                                <div class="col-md-3">
                                    <label class="pull-left">
                                    </label>

                                </div>
                                <div class="col-md-5">
                                </div>
                                <div class="col-md-3">
                                    <label class="pull-left">
                                        Category
                                    </label>
                                    <b class="pull-right">:</b>
                                </div>
                                <div class="col-md-5">
                                    <asp:DropDownList ID="ddlCategory2" runat="server" ToolTip="Select Category">
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-3">
                                    <asp:Button ID="btnSearch" Text="Search" CssClass="ItDoseButton" runat="server" TabIndex="13"
                                        OnClick="btnSearch_Click1" ToolTip="Click To Search" />
                                </div>
                                <div class="col-md-5">
                                </div>
                            </div>
                        </div>
                        <div class="col-md-1"></div>
                    </div>
                    <table style="width: 100%; border-collapse: collapse">
                        <tr>
                            <td colspan="4" style="text-align: left">
                                <Ajax:UpdatePanel ID="UpdatePanel1" runat="server">
                                    <ContentTemplate>
                                        <asp:GridView ID="grdSubCategory" runat="server" Width="100%" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                            OnRowDataBound="grdSubCategory_RowDataBound" OnSelectedIndexChanged="grdSubCategory_SelectedIndexChanged">
                                            <Columns>
                                                <asp:TemplateField HeaderText="S.No.">
                                                    <ItemTemplate>
                                                        <%#Container.DataItemIndex+1 %>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="20px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="SubCategory Name">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtName" MaxLength="50" runat="server" Text='<%#Eval("Name") %>' Width="230px"></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="240px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Display Name">
                                                    <ItemTemplate>
                                                        <asp:DropDownList ID="ddlDisplayName2" Width="280px" runat="server">
                                                        </asp:DropDownList><asp:Label ID="lblDisplayName" runat="server" Text='<%#Eval("DisplayName") %>' Visible="false"></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="280px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Print&nbsp;Order&nbsp;No.">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtDisplayPriority" MaxLength="3" Width="45px" runat="server" Text='<%#Eval("DisplayPriority") %>'></asp:TextBox>
                                                        <cc1:FilteredTextBoxExtender ID="ftbPriority" runat="server" TargetControlID="txtDisplayPriority" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Abbreviation">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtabbreviation" MaxLength="4" Width="90px" runat="server" Text='<%#Eval("abbreviation") %>'></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Validity Period">
                                                    <ItemTemplate>
                                                        <asp:TextBox ID="txtValidityPeriod" MaxLength="3" Width="45px" runat="server" Text='<%#Eval("DocValidityPeriod") %>'></asp:TextBox>
                                                        <cc1:FilteredTextBoxExtender ID="ftbValidityPeriod" runat="server" TargetControlID="txtValidityPeriod" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="60px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="Active">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblActive" Visible="false" runat="server" Text='<%#Eval("Active") %>'></asp:Label><asp:RadioButtonList
                                                            ID="rbtnActive2" runat="server" RepeatDirection="Horizontal">
                                                            <asp:ListItem>YES</asp:ListItem>
                                                            <asp:ListItem>NO</asp:ListItem>
                                                        </asp:RadioButtonList><asp:Label ID="lblConfigID" Visible="false" runat="server" Text='<%#Eval("ConfigID") %>'></asp:Label><asp:Label
                                                            ID="lblSubCategoryID" Visible="false" runat="server" Text='<%#Eval("SubCategoryID") %>'></asp:Label><asp:Label
                                                                ID="lblCategoryID" Visible="false" runat="server" Text='<%#Eval("CategoryID") %>'></asp:Label><asp:Label
                                                                    ID="lblDescription" Visible="false" runat="server" Text='<%#Eval("Description") %>'></asp:Label>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                                                </asp:TemplateField>
                                                <asp:TemplateField HeaderText="IsAsset">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblIsAsset" Visible="false" runat="server" Text='<%#Eval("IsAsset") %>'></asp:Label>
                                                        <asp:RadioButtonList ID="rbtnIsAsset" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="rbtnIsAsset_SelectedIndexChanged">
                                                            <asp:ListItem Text="YES">YES</asp:ListItem>
                                                            <asp:ListItem Text="NO">NO</asp:ListItem>
                                                        </asp:RadioButtonList>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                                                </asp:TemplateField>

                                                  <asp:TemplateField HeaderText="Scale OF Cost" >
                                                    <ItemTemplate>
                                                        <asp:TextBox runat="server" ID="txtScaleOfCost" Text='<%#Eval("ScaleOfCost") %>' onkeypress="$commonJsNumberValidation(event)" onkeydown="$commonJsPreventDotRemove(event)" onlynumber="8" decimalplace="6" max-value="100"
                                                            ></asp:TextBox>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="110px" />
                                                </asp:TemplateField>



                                                <asp:TemplateField HeaderText="Department">
                                                    <ItemTemplate>
                                                        <asp:Label ID="lblDepartment" Visible="false" runat="server" Text='<%#Eval("Asset_DepartId")%>'></asp:Label>
                                                        <asp:DropDownCheckBoxes ID="ddlDepartment" runat="server" AddJQueryReference="True" UseButtons="false" UseSelectAllNode="True" Height="23px" CssClass="requiredField requiredField1">
                                                            <Texts SelectBoxCaption="Select" />
                                                        </asp:DropDownCheckBoxes>
                                                    </ItemTemplate>
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                    <HeaderStyle CssClass="GridViewHeaderStyle" Width="185px" />
                                                </asp:TemplateField>
                                                <asp:CommandField ShowSelectButton="True" SelectText="Edit" ButtonType="Image" SelectImageUrl="~/Images/edit.png" HeaderText="Edit" HeaderStyle-CssClass="GridViewHeaderStyle">
                                                    <ItemStyle CssClass="GridViewLabItemStyle" />
                                                </asp:CommandField>
                                            </Columns>
                                        </asp:GridView>
                                    </ContentTemplate>
                                </Ajax:UpdatePanel>
                                <Ajax:UpdateProgress ID="UpdateProgress1" runat="server" AssociatedUpdatePanelID="UpdatePanel1">
                                    <ProgressTemplate>
                                        <asp:Image ID="Image1" runat="server" Width="38px" Height="31px" ImageUrl="~/Images/25-1.gif"></asp:Image><br />
                                    </ProgressTemplate>
                                </Ajax:UpdateProgress>
                            </td>
                        </tr>
                    </table>

                </div>
            </asp:View>
        </asp:MultiView><br />
    </div>

    <%-- <script type="text/javascript" src="../../Scripts/Common.js"></script>
	<script type="text/javascript" src="../../Scripts/jquery.slimscroll.js"></script>
	<script type="text/javascript" src="../../Scripts/chosen.jquery.min.js"></script>--%>

    <script type="text/javascript">
        function SaveDepartId() {
            var selectedvals = "";
            $.each($('#<%=ddlDept.ClientID%> input[type=checkbox]:checked'), function () {
                selectedvals += $(this).val() + ",";
            });
            selectedvals = selectedvals.slice(0, -1);

            var rbc = $('[id$=rbisAsset] input:checked').val();

            if (rbc == "YES") {
                $.ajax({
                    url: 'SubCategoryMaster.aspx/SaveDepartment',
                    data: '{DepartID:"' + selectedvals + '"}',
                    dataType: "json",
                    contentType: "application/json;charset=UTF-8",
                    async: false,
                    type: "POST",
                }).done(function (r) {

                });
            }
        }

        function GetError() {
            alert("Select atleast one department");
        }
    </script>
</asp:Content>
