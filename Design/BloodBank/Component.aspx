<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Component.aspx.cs" Inherits="Design_BloodBank_Component" %>

<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/Message.js" type="text/javascript" ></script>
    <script type="text/javascript">
        $(function () {
            $('#txtcollectfrom').change(function () {
                ChkDate();
            });
            $('#txtcollectTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtcollectfrom').val() + '",DateTo:"' + $('#txtcollectTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdComponent.ClientID %>').hide();

                    }
                    else {
                        $('#<%=lblMsg.ClientID %>').text('');
                        $('#<%=btnSearch.ClientID %>').removeProp('disabled');

                    }
                }
            });
        }

    </script>
    <script type="text/javascript">
        $(document).ready(function () {
            $(".status").mouseover(function () {
                this.parentNode.parentNode.style.backgroundColor = 'cyan';
            });
            $(".status").mouseout(function () {
                this.parentNode.parentNode.style.backgroundColor = 'transparent';
            });

        });

        function validate() {
            if (Page_IsValid) {
                document.getElementById('<%=btnSave.ClientID%>').disabled = true;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Submitting...';
                __doPostBack('ctl00$ContentPlaceHolder1$btnSave', '');
            }
            else {
                document.getElementById('<%=btnSave.ClientID%>').disabled = false;
                document.getElementById('<%=btnSave.ClientID%>').value = 'Save';
            }
        }
        $(document).ready(function () {
            $("#<%=grvListForm.ClientID %>").find("input[id$=chkComp]").each(function () {
                this.onclick = function () {
                    if (this.checked) {
                        this.parentNode.parentNode.style.backgroundColor = 'cyan';
                        setGoal();
                    }
                    else {
                        this.parentNode.parentNode.style.backgroundColor = 'transparent';
                        setGoal();
                    }
                };
            });
        });
        function setGoal() {
            var j = 0;
            a = document.getElementsByTagName("input");
            for (i = 0; i < a.length; i++) {
                if (a[i].type == "checkbox") {


                    if (a[i].checked) {
                        j = Number(j) + 1;
                    }

                }
            }
            if (j > 0) {
                document.getElementById('<%=btnSave.ClientID %>').disabled = false;
            }
            else {
                document.getElementById('<%=btnSave.ClientID %>').disabled = true;
            }

        }


        function clearform() {

            a = document.getElementsByTagName("input");
            for (i = 0; i < a.length; i++) {
                if (a[i].type == "text") {
                    a[i].value = "";
                }
            }

        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>

    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">

            <b>Component Creation</b><br />
            <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>

        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Coll. Id
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDonationId" runat="server" MaxLength="20" TabIndex="1"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor Id
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtDonorId" runat="server" MaxLength="20" TabIndex="2"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Donor Name 
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtName" runat="server" MaxLength="50" TabIndex="3"></asp:TextBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Blood Group
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBloodgroup" runat="server" TabIndex="4">
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Tube No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBagNo" runat="server" MaxLength="10" TabIndex="5"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Bag Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBagType" runat="server" TabIndex="6">
                            <asp:ListItem Text="All" Value="All"></asp:ListItem>
                            <asp:ListItem Text="Single" Value="Single"></asp:ListItem>
                            <asp:ListItem Text="Double" Value="Double"></asp:ListItem>
                            <asp:ListItem Text="Triple" Value="Triple"></asp:ListItem>
                        </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect From
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtcollectfrom" runat="server" ClientIDMode="Static"
                            TabIndex="7"></asp:TextBox>
                        <cc1:CalendarExtender ID="calcollectfrom" TargetControlID="txtcollectfrom" Format="dd-MMM-yyyy"
                            runat="server">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Collect To
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtcollectTo" runat="server" ClientIDMode="Static" TabIndex="8"></asp:TextBox>
                        <cc1:CalendarExtender ID="calcollectTo" TargetControlID="txtcollectTo" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                              <label class="pull-left">
                                Status
                            </label>
                            <b class="pull-right">:</b>

                        </div>
                       <div class="col-md-5">
                           <asp:DropDownList ID="ddlStatus" runat="server">
                               <asp:ListItem Selected="True" Value="1">Yes</asp:ListItem>
                               <asp:ListItem Value="0">Yes</asp:ListItem>
                           </asp:DropDownList>
                           </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="ItDoseButton" Text="Search" OnClick="btnSearch_Click"
                ValidationGroup="search" TabIndex="9" />&nbsp;
            <asp:Label ID="lblDonor1" runat="server" Visible="false"></asp:Label>
        </div>
        <asp:Panel ID="pnlhide" Visible="false" runat="server">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grdComponent" runat="server" AutoGenerateColumns="false" CssClass="GridViewStyle"
                    OnRowCommand="grdComponent_RowCommand" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%#Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Donor ID">
                            <ItemTemplate>
                                <asp:Label ID="lblDonorID" runat="server" Text='<%# Eval("Visitor_ID") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection ID">
                            <ItemTemplate>
                                <asp:Label ID="lblDonationID" runat="server" Text='<%# Eval("Bloodcollection_id") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="120px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Name">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("Name") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Sex">
                            <ItemTemplate>
                                <%#Eval("Gender")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Group">
                            <ItemTemplate>
                                <asp:Label ID="lblGroup" runat="server" Text='<%# Eval("BloodGroup") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Date">
                            <ItemTemplate>
                                <%#Eval("Collecteddate")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Tube No.">
                            <ItemTemplate>
                                <%#Eval("BBTubeNo")%>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="90px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag">
                            <ItemTemplate>
                                <asp:Label ID="lblBagType1" runat="server" Text='<%# Eval("BagType") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Volume">
                            <ItemTemplate>
                                <asp:Label ID="lblVolume1" runat="server" Text='<%# Eval("Volume") %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="50px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Status">
                            <ItemTemplate>
                                <asp:Label ID="lblBCID" runat="server" Visible="false" Text='<%#Eval("Bloodcollection_id") %>'></asp:Label>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/Post.gif" class="status"
                                    CommandName="AResult" CommandArgument='<%#Container.DataItemIndex %>' CausesValidation="false" />
                                <asp:Label ID="lblTubeNo" runat="server" Visible="false" Text='<%#Eval("BBTubeNo") %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="40px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
                <asp:Panel ID="pnlDetail" runat="server" Visible="false">
                    <div>
                        <div style="float: left; clear: right; padding-left: 125px;">
                            <asp:Label ID="lblID" runat="server" Visible="False"></asp:Label>

                            <label class="labelForTag">
                                &nbsp;&nbsp;&nbsp;Bag Type :</label>
                            <asp:Label ID="lblBagType" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            <br />
                            <br />
                            <label class="labelForTag">
                                Blood Group :</label>
                            <asp:Label ID="lblGroup1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                        </div>
                        <div style="float: left; clear: right; padding-left: 100px;">
                            <label class="labelForTag">
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Name :</label>
                            <asp:Label ID="lblName1" runat="server" CssClass="ItDoseLabelSp"></asp:Label><br />
                            <br />
                            <label class="labelForTag">
                                Collection ID :</label>
                            <asp:Label ID="lblDonation1" runat="server" CssClass="ItDoseLabelSp"></asp:Label>
                            <br />
                            &nbsp;
                        </div>
                        <div style="float: left; padding-left: 100px;">
                            <label class="labelForTag">
                                Tube No. :</label>
                            <asp:Label ID="lblBagNo" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;<br />
                            <br />
                            <label class="labelForTag">
                                &nbsp;&nbsp;Volume :</label>
                            <asp:Label ID="lblVolume" runat="server" CssClass="ItDoseLabelSp"></asp:Label>&nbsp;<br />
                            <br />
                        </div>
                    </div>
                </asp:Panel>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlComponent" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:GridView ID="grvListForm" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                    OnRowDataBound="grvListForm_RowDataBound" Width="100%">
                    <Columns>
                        <asp:TemplateField HeaderText="">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkComp" runat="server" onclick="setGoal();" />
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="25px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component">
                            <ItemTemplate>
                                <asp:Label ID="lblGrdComponentId" Text='<%# Eval("id") %>' Visible="false" runat="server"></asp:Label>
                                <%# Eval("ComponentName") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="200px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Bag Type">
                            <ItemTemplate>
                                <%# Eval("BagType") %>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Volume">
                            <ItemTemplate>
                                <asp:TextBox ID="txtVolume" runat="server" Width="60px" BackColor="#ffffcc" MaxLength="3"
                                    class="status1 txtVol"></asp:TextBox>
                                
                                    <cc1:FilteredTextBoxExtender ID="ftbetxtVolume" runat="server" TargetControlID="txtVolume"
                                        FilterType="Numbers" />
                                <asp:RequiredFieldValidator ID="reqshelf1" SetFocusOnError="true" runat="server"
                                    ControlToValidate="txtVolume" ValidationGroup="save" InitialValue="0" ErrorMessage="*"
                                    Display="None"></asp:RequiredFieldValidator>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Collection Date">
                            <ItemTemplate>
                                <asp:Label ID="lbldtCreate" runat="server" Text='<%# Eval("dtCreate") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lbldtExpiry" runat="server" Text='<%# Eval("dtExpiry") %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="100px" />
                            <ItemStyle CssClass="GridViewItemStyle" />
                        </asp:TemplateField>
                    </Columns>
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                </asp:GridView>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                <asp:Button ID="btnSave" Text="Save" CssClass="ItDoseButton" runat="server" ValidationGroup="save"
                    OnClick="btnSave_Click" Enabled="False" OnClientClick="return validate();" />
            </div>
        </asp:Panel>
    </div>

    <script type="text/javascript">
        $(".txtVol").blur(function () {
            var total = $('[id$=lblVolume]').text();
            var lastIndex = total.lastIndexOf(" ");
            total = total.substring(0, lastIndex);

            var len = $(this).closest(".GridViewStyle tbody").find('tr').length;
            var totalNum = 0;
            $(this).closest(".GridViewStyle tbody").find('tr').each(function (i) {
                if (i != 0) {
                    var $fieldset = $(this);
                    var vv = $('input:text:eq(0)', $fieldset).val();
                    if (vv != "") {
                        totalNum = parseInt(totalNum) + parseInt(vv);
                        if (totalNum > total) {
                            $('input:text:eq(0)', $fieldset).val("");
                            $('input:text:eq(0)', $fieldset).focus();
                        }
                    }
                }
                if (totalNum > total) {
                    //alert("Volume shouldn't be exceed " + total + " ml");
                    $('[id$=lblMsg]').text("Volume shouldn't be exceed " + total + " ml");
                }
                else {
                    $('[id$=lblMsg]').text("");
                }
            });
            var v = $(this).val();

        });
    </script>
</asp:Content>
