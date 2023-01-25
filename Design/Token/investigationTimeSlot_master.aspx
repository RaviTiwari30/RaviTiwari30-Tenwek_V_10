<%@ Page Title="" Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="investigationTimeSlot_master.aspx.cs" Inherits="Design_OPD_investigation_master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        $(document).ready(function () {
            $("#<%=grdSubCategory.ClientID %>").find("input[id$=chkSubCategory]").each(function () {
                this.onclick = function () {
                    if (this.checked) {
                        this.parentNode.parentNode.style.backgroundColor = 'cyan';
                    }
                    else {
                        this.parentNode.parentNode.style.backgroundColor = 'transparent';
                        $(this).find("input[id$=txtTestCount]").removeClass('requiredField');
                    }
                };
            });
        });
        function checkValuefill(btn) {
            var count = 0;
            $("#<%=grdSubCategory.ClientID %>").find("input[id$=chkSubCategory]").each(function () {
                if (this.checked) {
                    this.parentNode.parentNode.style.backgroundColor = 'cyan';
                    count = count + 1;
                }
                else {
                    this.parentNode.parentNode.style.backgroundColor = 'transparent';
                }
            });
            if (count == 0) {
                $('#lblerrmsg').text('Please Select One Subcategory')
                return false;
            }
        }
    </script>
    <cc1:ToolkitScriptManager runat="server" ID="scriptManager"></cc1:ToolkitScriptManager>

    <div id="Pbody_box_inventory">

        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>Investigation Time Slot Master</b>
        </div>
        <div id="div1" style="text-align: center;" class="POuter_Box_Inventory">
            <div class="row">
                <asp:Label ID="lblerrmsg" runat="server" CssClass="ItDoseLblError" ClientIDMode="Static"></asp:Label>
            </div>
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Category Name.</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <%--<asp:DropDownList ID="ddlCategory" runat="server" ClientIDMode="Static" onchange="$bindSubCategory(1,$('#ddlCategory').val(),function(){});"></asp:DropDownList>--%>
                            <asp:DropDownList ID="ddlCategory" runat="server" ClientIDMode="Static" OnSelectedIndexChanged="ddlCategory_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </div>
                        <div class="col-md-3" id="divlblSubCategory" runat="server" visible="false">
                            <label class="pull-left">Sub Category</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5" id="divddlSub" runat="server" visible="false">
                            <asp:DropDownList ID="ddlSubCategory" runat="server" ClientIDMode="Static"></asp:DropDownList>
                        </div>
                        <div class="col-md-5">
                            <asp:Button ID="btnSearch" runat="server" Text="Search" OnClick="btnSearch_Click" />
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>

        <div class="POuter_Box_Inventory" id="divLabDetail" style="height: 325px; overflow-y: auto;" runat="server" clientidmode="Static" visible="false">
            <div class="Purchaseheader">
                Department Test Count Details
            </div>
            <div class="col-md-24">
                <asp:GridView ID="grdSubCategory" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle" Width="100%" Height="52px" Style="margin-left: 0px">
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="SubCategory">
                            <ItemTemplate>
                                <asp:Label ID="lblSubCategoryName" runat="server" Text='<%# Eval("Name")%>'></asp:Label>
                                <asp:Label ID="lblSubCategoryID" runat="server" Text='<%# Eval("SubCategoryID")%>' Visible="false"></asp:Label>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Center" Width="100px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Total Test Count">
                            <ItemTemplate>
                                <asp:TextBox ID="txtTestCount" runat="server" ClientIDMode="Static" Text='<%#Eval("TotalTestLimit") %>' MaxLength="20" Width="100px"></asp:TextBox>
                                <cc1:FilteredTextBoxExtender ID="ftbtxtTestCount" runat="server" FilterType="Numbers"
                                    TargetControlID="txtTestCount">
                                </cc1:FilteredTextBoxExtender>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" HorizontalAlign="Center" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Select">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkSubCategory" runat="server" ClientIDMode="Static" Checked='<%# Convert.ToBoolean(Eval("isTestLimit")) %>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" Width="30px" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" Width="30px" />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </div>
        <div class="POuter_Box_Inventory" id="divRadioDetail" runat="server" clientidmode="Static" visible="false">
            <div class="Purchaseheader">
                Department Schedule Details
            </div>
            <div class="row">
                <div class="col-md-24">
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">Modality</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlModality" runat="server" OnSelectedIndexChanged="ddlModality_SelectedIndexChanged" AutoPostBack="true"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4" style="display: none;">
                            <label class="pull-left">
                                <asp:RadioButtonList ID="rbtnType" runat="server" RepeatDirection="Horizontal">
                                    <asp:ListItem Selected="True" Value="1">By Days</asp:ListItem>
                                </asp:RadioButtonList>
                            </label>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Days
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div id="trDaysWise" runat="server" class="col-md-16">

                            <asp:CheckBox ID="chkMon" runat="server" Height="11px" TabIndex="10" Text="Mon" Width="72px"
                                ToolTip="Check Monday" />
                            <asp:CheckBox ID="chkTues" runat="server" Height="11px" TabIndex="11" Text="Tues"
                                Width="75px" ToolTip="Check Tuesday" />
                            <asp:CheckBox ID="chkWed" runat="server" Height="11px" TabIndex="12" Text="Wed" Width="74px"
                                ToolTip="Check Wednesday" />
                            <asp:CheckBox ID="chkThur" runat="server" Height="11px" TabIndex="13" Text="Thur"
                                Width="72px" ToolTip="Check Thrusday" />
                            <asp:CheckBox ID="chkFri" runat="server" Height="11px" TabIndex="14" Text="Fri" Width="62px"
                                ToolTip="Check Friday" />
                            <asp:CheckBox ID="chkSat" runat="server" Height="11px" TabIndex="15" Text="Sat" Width="67px"
                                ToolTip="Check Saturday" />
                            <asp:CheckBox ID="chkSun" runat="server" Height="11px" TabIndex="16" Text="Sun" Width="70px"
                                ToolTip="Check Sunday" />
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Shift
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:DropDownList ID="ddlDocTimingShift" runat="server" ToolTip="Select Shift" class="requiredField"></asp:DropDownList>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-2">
                            <label class="pull-left">
                                Centre
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:DropDownList ID="ddlCentre" runat="server" AutoPostBack="true" OnSelectedIndexChanged="ddlCentre_SelectedIndexChanged"></asp:DropDownList>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                Start Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHr1" runat="server" MaxLength="2" TabIndex="17"
                                Width="33px" ToolTip="Enter Start Time"></asp:TextBox>
                            <asp:TextBox ID="txtMin1" runat="server" MaxLength="2" TabIndex="18"
                                Width="33px" ToolTip="Enter Minutes"></asp:TextBox>
                            <asp:DropDownList ID="cmbAMPM1" runat="server" TabIndex="19"
                                Width="57px" ToolTip="Select AM Or PM">
                                <asp:ListItem>AM</asp:ListItem>
                                <asp:ListItem>PM</asp:ListItem>
                            </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftbe1" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtHr1">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="ftbe2" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtMin1">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RangeValidator ID="rangetxtHr1" runat="server" ControlToValidate="txtHr1" MinimumValue="0"
                                MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                            <asp:RangeValidator ID="rangetxtMin1" runat="server" ControlToValidate="txtMin1"
                                MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                        </div>
                        <div class="col-md-2">
                            <label class="pull-left">
                                End Time
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-4">
                            <asp:TextBox ID="txtHr2" runat="server" MaxLength="2" TabIndex="20"
                                Width="33px" ToolTip="Enter End Time "></asp:TextBox>
                            <asp:TextBox ID="txtMin2" runat="server" MaxLength="2" TabIndex="21"
                                Width="33px" ToolTip="Enter Minutes"></asp:TextBox><asp:DropDownList ID="cmbAMPM2"
                                    runat="server" TabIndex="22" Width="57px" ToolTip="Select AM Or PM">
                                    <asp:ListItem>AM</asp:ListItem>
                                    <asp:ListItem>PM</asp:ListItem>
                                </asp:DropDownList>
                            <cc1:FilteredTextBoxExtender ID="ftbe3" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtHr2">
                            </cc1:FilteredTextBoxExtender>
                            <cc1:FilteredTextBoxExtender ID="ftbe4" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtMin2">
                            </cc1:FilteredTextBoxExtender>
                            <asp:RangeValidator ID="rangetxtHr2" runat="server" ControlToValidate="txtHr2" MinimumValue="0"
                                MaximumValue="12" ErrorMessage="Invalid Hours Time" ForeColor="Red"></asp:RangeValidator>
                            <asp:RangeValidator ID="rangetxtMin2" runat="server" ControlToValidate="txtMin2"
                                MinimumValue="0" MaximumValue="60" ErrorMessage="Invalid Min Time" ForeColor="Red"></asp:RangeValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Duration for Patient
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-2">
                            <asp:DropDownList ID="ddlduration" runat="server" Width="50px" TabIndex="26" ToolTip="Select Duration For Patients">
                                <asp:ListItem>5</asp:ListItem>
<asp:ListItem>10</asp:ListItem>
                                <asp:ListItem>15</asp:ListItem>
<asp:ListItem>20</asp:ListItem>
                                <asp:ListItem>25</asp:ListItem>
<asp:ListItem>30</asp:ListItem>
                                <asp:ListItem>35</asp:ListItem>
<asp:ListItem>40</asp:ListItem>
<asp:ListItem>45</asp:ListItem>
                                <asp:ListItem>50</asp:ListItem>
                                <asp:ListItem>60</asp:ListItem>
                                <asp:ListItem>70</asp:ListItem>
                                <asp:ListItem>80</asp:ListItem>
                                <asp:ListItem>90</asp:ListItem>
                                <asp:ListItem>100</asp:ListItem>
                                <asp:ListItem>110</asp:ListItem>
                                <asp:ListItem>120</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-1">
                            <label class="pull-left">Minutes</label>
                        </div>
                    </div>
                    <div class="row"></div>
                    <div class="row">
                        <div class="col-md-10">
                        </div>
                        <div class="col-md-4">

                            <asp:Button ID="btntimings" runat="server" CssClass="ItDoseButton" OnClick="btntimings_Click" TabIndex="25" Text="Add Timings" ToolTip="Click To Add Timings" />

                        </div>
                        <div class="col-md-10">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-24">
                            <asp:GridView ID="grdTime" runat="server" AutoGenerateColumns="False" CssClass="GridViewStyle"
                                OnRowDeleting="grdTime_RowDeleting" Width="100%" Height="52px" Style="margin-left: 0px">
                                <Columns>
                                    <asp:BoundField DataField="CentreName" HeaderText="Centre" ItemStyle-Width="150px" />
                                    <asp:BoundField DataField="Day" HeaderText="Days" ItemStyle-Width="150px" />
                                    <asp:BoundField DataField="StartTime" HeaderText="Start Time" />
                                    <asp:BoundField DataField="EndTime" HeaderText="End Time" />
                                    <asp:BoundField DataField="AvgTime" HeaderText="Duration For Patient" />
                                    <asp:BoundField DataField="StartBufferTime" HeaderText="Start BT" Visible="false" />
                                    <asp:BoundField DataField="EndBufferTime" HeaderText="End BT" Visible="false" />
                                    <asp:BoundField DataField="ShiftName" HeaderText="Shift" />
                                    <asp:TemplateField Visible="false">
                                        <ItemTemplate>
                                            <asp:Label ID="lblStartTime" runat="server" Text='<%#Eval("StartTime") %>'></asp:Label>
                                            <asp:Label ID="lblEndTime" runat="server" Text='<%#Eval("EndTime") %>'></asp:Label>
                                            <asp:Label ID="lblShiftName" runat="server" Text='<%#Eval("ShiftName") %>'></asp:Label>
                                            <asp:Label ID="lblCentreID" runat="server" Text='<%#Eval("CentreID") %>'></asp:Label>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:CommandField ShowDeleteButton="True" ButtonType="Image" DeleteImageUrl="~/Images/Delete.gif" />
                                </Columns>
                                <HeaderStyle CssClass="GridViewHeaderStyle" />
                                <AlternatingRowStyle CssClass="GridViewItemStyle" />
                            </asp:GridView>
                        </div>
                    </div>
                    <div class="col-md-1"></div>
                </div>
                <table id="Table1" style="width: 100%" runat="server">
                    <tr id="Tr1" runat="server" visible="false">
                        <td style="width: 14%; text-align: right">Start Buffer Time :&nbsp;
                        </td>
                        <td style="width: 45%; text-align: left">
                            <asp:TextBox ID="txtStartBT" runat="server" Width="44px" TabIndex="23" ToolTip="Enter Start Buffer Time"></asp:TextBox>
                            ( in minutes )<cc1:FilteredTextBoxExtender ID="ftb5" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtStartBT">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                        <td style="width: 20%; text-align: right">End Buffer Time :
                        </td>
                        <td style="width: 35%; text-align: left">
                            <asp:TextBox ID="txtEndBT" runat="server" Width="44px" TabIndex="24" ToolTip="Enter End Buffer Time"></asp:TextBox>
                            &nbsp;(In Minutes)<cc1:FilteredTextBoxExtender ID="ftb6" runat="server" FilterType="Custom,Numbers"
                                TargetControlID="txtEndBT">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="POuter_Box_Inventory textCenter">
            <asp:Button ID="btnSaveLab" runat="server" Text="Save Lab Schedule" OnClick="btnSaveLab_Click" Visible="false" OnClientClick="return checkValuefill(this);" />
            <asp:Button ID="btnSaveSchedule" runat="server" Text="Save Radio Schedule" OnClick="btnSaveSchedule_Click" Visible="false" />
        </div>
    </div>



</asp:Content>

