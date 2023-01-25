<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" EnableEventValidation="False" CodeFile="MembershipCard.aspx.cs" Inherits="Design_OPD_MemberShipCard_MembershipCard" Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script language="javascript" type="text/javascript">
        function Disabele() {
            document.getElementById("ctl00$ContentPlaceHolder1$txtPID,ctl00$ContentPlaceHolder1$btnSave").disabled = true;
            __doPostBack('ctl00$ContentPlaceHolder1$btnSave')
        }
        function AddDate() {
            var fromdate = document.getElementById('<%=txtValidFromDate.ClientID %>').value;
            var myDate = new Date();
            myDate.setDate(fromdate);
        }



        var openGridImage = function (elem) {
            $(elem).parent().find('input[type=file]').trigger('click');
        }



    </script>
    <Ajax:ScriptManager ID="sm" runat="server" />
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align:center">
            <b>Membership Card</b>
            <br />
            <asp:Label ID="lblmsg" runat="server" Font-Bold="True" Font-Size="9pt" ForeColor="Red"></asp:Label></span>
            
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Details Of Family Head
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                <b>Barcode</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPID" runat="server" style="width:173px;"></asp:TextBox>
                            <asp:Label ID="lblMRNo" runat="server" Visible="False"></asp:Label>
                              <asp:Button ID="btnPIDSearch" TabIndex="50" ValidationGroup="Search" runat="server" Text="Search" OnClick="btnPIDSearch_Click"  />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                <asp:Label ID="lblSelfID" runat="server" Visible="false"></asp:Label>Card No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtCardNo"  CssClass="requiredField" runat="server"></asp:TextBox>                            
                        </div>
                         <div class="col-md-3">
                             <asp:Button ID="btnSearch" TabIndex="50" ValidationGroup="Search" runat="server" Text="Search" OnClick="btnSearch_Click"  />
                         </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:DropDownList ID="cmbTitle" runat="server"  TabIndex="1" ></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                             <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Age
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtAge" runat="server" CssClass="ItDoseDropText"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlMemberAge" runat="server">
                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                            </asp:DropDownList>
                             <cc1:FilteredTextBoxExtender ID="fc1" runat="Server" TargetControlID="txtAge" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Gender
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlGender" CssClass="requiredField" runat="server">
                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                <asp:ListItem Value="Female">Female</asp:ListItem>
                            </asp:DropDownList>
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
                            <asp:TextBox ID="txtAddress" runat="server" CssClass="requiredField" TextMode="MultiLine" style="height: 30px; text-transform:uppercase;max-width: 100%;max-height:70px" ></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Phone
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtPhone" runat="server"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender2" runat="server" FilterType="Numbers"
                                TargetControlID="txtPhone">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Mobile
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtMobile" runat="server" MaxLength="15"></asp:TextBox>
                            <cc1:FilteredTextBoxExtender ID="FilteredTextBoxExtender1" runat="server" FilterType="Numbers"
                                TargetControlID="txtMobile">
                            </cc1:FilteredTextBoxExtender>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Email
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail" ErrorMessage="Woring Email Address" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Membership Card
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlMembershipCard" runat="server" OnSelectedIndexChanged="ddlMembershipCard_SelectedIndexChanged"  AutoPostBack="True"></asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                               <b> Card Amount</b>
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:Label ID="lblAmount" runat="Server" Font-Bold="true"></asp:Label>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Photo
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:FileUpload ID="PhotoUploader" ClientIDMode="Static" runat="server" />
                            <asp:Image ID="imgMain" runat="server" Height="63px" Width="60px" Visible="False" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Valid From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtValidFromDate"  CssClass="requiredField" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="calExdTxtSerachModelToDate" TargetControlID="txtValidFromDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Valid To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtValidToDate"  CssClass="requiredField" runat="server"></asp:TextBox>
                            <cc1:CalendarExtender ID="CalendarExtender1" TargetControlID="txtValidToDate" Format="dd-MMM-yyyy" runat="server" ></cc1:CalendarExtender> 
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Receipt No of Card
                            </label>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtreceiptno" runat="server" CssClass="requiredField" ></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Source
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlSource" runat="server">
                                <asp:ListItem>HOSPITAL</asp:ListItem>
                                <asp:ListItem>CAMP</asp:ListItem>
                                <asp:ListItem>Walk IN</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Source  Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtSourceName" runat="server"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Referred By
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlReferedBy" runat="server">
                                <asp:ListItem>MARKETING</asp:ListItem>
                                <asp:ListItem>OPD</asp:ListItem>
                                <asp:ListItem>OTHER</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Referred By Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtReferedByname" runat="server"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlStatus" runat="server"  >
                                <asp:ListItem>Under Process</asp:ListItem>
                                <asp:ListItem>Dispatched</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
             <div class="row"></div>
        </div>
        <div  class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Details Of Family Member
            </div>
            <asp:GridView ID="MemberFamilyDetail" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" OnRowDataBound="MemberFamilyDetail_RowDataBound" Width="100%">
                                <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                                <Columns>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chk" Checked="True" runat="Server" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="S.No.">
                                        <ItemTemplate>
                                            <%# Container.DataItemIndex+1 %>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" VerticalAlign="Middle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Title">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="cmbTitle"  TabIndex="1" runat="server"  ToolTip="select  gender">
                                            </asp:DropDownList>

                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" VerticalAlign="Middle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>

                                    <asp:TemplateField HeaderText="Name">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtName" runat="server"></asp:TextBox>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" VerticalAlign="Middle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Age">
                                        <ItemTemplate>
                                            <asp:TextBox ID="txtAge" Width="40px" runat="server"></asp:TextBox>
                                            <asp:DropDownList ID="ddlAge" runat="server" Style="width: 70px">
                                                <asp:ListItem Value="YRS">YRS</asp:ListItem>
                                                <asp:ListItem Value="MONTH(S)">MONTH(S)</asp:ListItem>
                                                <asp:ListItem Value="DAYS(S)">DAYS(S)</asp:ListItem>
                                            </asp:DropDownList>
                                            <cc1:FilteredTextBoxExtender ID="fcAge" runat="server" TargetControlID="txtAge" FilterType="Numbers"></cc1:FilteredTextBoxExtender>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" VerticalAlign="Middle" Width="120px" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Gender">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlGender"  runat="server">
                                                <asp:ListItem Value="Male">Male</asp:ListItem>
                                                <asp:ListItem Value="Female">Female</asp:ListItem>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" VerticalAlign="Middle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Relation">
                                        <ItemTemplate>
                                            <asp:DropDownList ID="ddlRelation" runat="server">
                                                <%--<asp:ListItem Value="WIFE">WIFE</asp:ListItem>
                     <asp:ListItem Value="MOTHER">MOTHER</asp:ListItem>
                     <asp:ListItem Value="FATHER">FATHER</asp:ListItem>
                     <asp:ListItem Value="FATHER">HUSBAND</asp:ListItem>
                     <asp:ListItem Value="FATHER">SON</asp:ListItem>
                     <asp:ListItem Value="FATHER">DAUGHTER</asp:ListItem>
                     <asp:ListItem Value="FATHER">NEPHEW</asp:ListItem>
                     <asp:ListItem Value="FATHER">COUSIN</asp:ListItem>
                     <asp:ListItem Value="FATHER">UNCLE</asp:ListItem>
                     <asp:ListItem Value="FATHER">DAUGHTER-IN-LAW</asp:ListItem>
                     <asp:ListItem Value="FATHER">SON-IN-LAW</asp:ListItem>
                     <asp:ListItem Value="FATHER">FATHER-IN-LAW</asp:ListItem>
                     <asp:ListItem Value="FATHER">MOTHER-IN-LAW</asp:ListItem>--%>
                                            </asp:DropDownList>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" VerticalAlign="Middle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField  Visible="false" HeaderText="Photo">
                                        <ItemTemplate>
                                          

                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" VerticalAlign="Middle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>
                                    <asp:TemplateField ItemStyle-HorizontalAlign="Center">
                                        <ItemTemplate>
                                             <asp:FileUpload style="display:none" ID="PhotoUpload" runat="server" />
                                            <asp:Image ID="img"  onclick="openGridImage(this);" ImageUrl="~/Images/no-avatar.gif" runat="server" Width="60px" Height="63px"></asp:Image>
                                            <asp:Label ID="lblID" runat="server" Visible="false"></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle CssClass="GridViewItemStyle" />
                                        <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                                    </asp:TemplateField>


                                </Columns>
                            </asp:GridView>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSave" runat="server" OnClick="btnSave_Click" CssClass="save margin-on-top-btn" style="margin-top:3px" Text="Save" />
            <asp:Button ID="btnUpdate" runat="server" Visible="false" CssClass="save margin-on-top-btn" Text="Update" style="margin-top:3px" OnClick="btnUpdate_Click" />
            <asp:Button ID="btnCancel" ValidationGroup="Cancel" CssClass="save margin-on-top-btn" runat="server" Visible="false" style="margin-top:3px" Text="Cancel" OnClick="btnCancel_Click" />
        </div>
    </div>


</asp:Content>

