<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="BloodReturn.aspx.cs" Inherits="Design_BloodBank_BloodReturn" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
      <script type="text/javascript" src="../../Scripts/Message.js"></script>
    <script type="text/javascript">
        $(document).ready(function () {
            $('#txtfromdate').change(function () {
                ChkDate();
            });
            $('#txtdateTo').change(function () {
                ChkDate();
            });
        });
        function ChkDate() {
            $.ajax({
                url: "../common/CommonService.asmx/CompareDate",
                data: '{DateFrom:"' + $('#txtfromdate').val() + '",DateTo:"' + $('#txtdateTo').val() + '"}',
                type: "POST",
                async: true,
                dataType: "json",
                contentType: "application/json; charset=utf-8",
                success: function (mydata) {
                    var data = mydata.d;
                    if (data == false) {
                        $('#<%=lblMsg.ClientID %>').text('To date can not be less than from date!');
                        $('#<%=btnSearch.ClientID %>').prop('disabled', 'disabled');
                        $('#<%=grdSearchList.ClientID %>').hide();

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
        function clearAllField() {
            $(':text, textarea').val('');
        }
        function BloodReturn() {
            $('#Search').attr('disabled', true).val("Submiting...");

            $.ajax({
                url: "Services/VenderReturn.asmx/BloodReturnSearch",
                data: '{IPDNo:"' + $("#txtIPDNo").val() + '" ,RegNo:"' + $("#txtRegNo").val() + '",PName:"' + $("#txtPatientName").val() + '",FromDate:"' + $("#txtfromdate").val() + '",ToDate:"' + $("#txtdateTo").val() + '",PatientType:"' + $('#rdbType input:checked').val() + '"}',//
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d != "") {
                        PatientData = jQuery.parseJSON(result.d);
                        if (PatientData != "") {
                            var output = $('#tb_BloodSearch').parseTemplate(PatientData);
                            $('#BloodSearchOutput').html(output);
                            $('#BloodSearchOutput').show();
                            $("#<%=lblMsg.ClientID %>").text('');
                            $('#Search').attr('disabled', false).val("Search");

                        }
                    }
                    else {
                        $('#BloodSearchOutput').html();
                        $('#BloodSearchOutput').hide();
                        $("#<%=lblMsg.ClientID %>").text('Record Not Found');
                        $('#Search').attr('disabled', false).val("Search");

                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    $('#Search').attr('disabled', false).val("Search");

                }
            });
        }
        function chngcur() {
            document.body.style.cursor = 'pointer';

        }
        function ConfirmationReturn(rowid) {
            modelConfirmation('Return Blood Confirmation ?', 'Are you Sure To Return?', 'Yes', 'Cancel', function (response) {
                if (response)
                    ReturnRow(rowid);
            });
        }
        function ReturnRow(rowid) {
            var row = rowid;
            $("#<%=lblIssueID.ClientID %>").text($(row).closest('tr').find("#tdIssueID").html());
            $("#<%=lblIssuevolumn.ClientID %>").text($(row).closest('tr').find("#tdIssuevolumn").html());
            $("#<%=ltdLedgerTnxID.ClientID %>").text($(row).closest('tr').find("#tdLedgerTnxID").html());
            $("#<%=lblStockID.ClientID %>").text($(row).closest('tr').find("#tdStockID").html());
            $("#<%=lblComponentID.ClientID %>").text($(row).closest('tr').find("#tdComponentID").html());
            $("#<%=lblComponentName.ClientID %>").text($(row).closest('tr').find("#tdComponentName").html());
            $("#<%=lblPatientID.ClientID %>").text($(row).closest('tr').find("#tdMRNo").html());
            $("#<%=lblTransactionID.ClientID %>").text($(row).closest('tr').find("#tdTransactionID").html());
            $("#<%=lblItemID.ClientID %>").text($(row).closest('tr').find("#tdItemID").html());
            $("#<%=lblBBTubeNo.ClientID %>").text($(row).closest('tr').find("#tdBBTubeNo").html());
            $("#<%=lblLedgerTransactionNo.ClientID %>").text($(row).closest('tr').find("#tdLedgerTransactionNo").html());
            var data = new Array();
            var obj = new Object();
            obj.IssueID = $("#<%=lblIssueID.ClientID %>").text();
            obj.Issuevolumn = $("#<%=lblIssuevolumn.ClientID %>").text();
            obj.LedgerTnxID = $("#<%=ltdLedgerTnxID.ClientID %>").text();
            obj.StockID = $("#<%=lblStockID.ClientID %>").text();
            obj.ComponentID = $("#<%=lblComponentID.ClientID %>").text();
            obj.ComponentName = $("#<%=lblComponentName.ClientID %>").text();
            obj.PatientId = $("#<%=lblPatientID.ClientID %>").text();
            obj.TransactionID = $("#<%=lblTransactionID.ClientID %>").text();
            obj.ItemID = $("#<%=lblItemID.ClientID %>").text();
            obj.BBTubeNo = $("#<%=lblBBTubeNo.ClientID %>").text();
            obj.LedgerTransactionNo = $("#<%=lblLedgerTransactionNo.ClientID %>").text();
            obj.Type = $(row).closest('tr').find("#tdType").html();
            data.push(obj);
            $.ajax({
                url: "Services/VenderReturn.asmx/SaveBloodReturn",
                data: JSON.stringify({ Data: data }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result.d == "1") {
                        BloodReturn();
                        $("#<%=lblMsg.ClientID %>").text('Record Saved Successfully');
                        $("#txtIPDNo").val('');
                        $("#txtRegNo").val('');
                        $("#txtPatientName").val('');

                    }
                    else if (result.d == "3") {
                        $("#<%=lblMsg.ClientID %>").text('Patient Bill Already Generated.');
                    }
                    else if (result.d == "0") {
                        $("#<%=lblMsg.ClientID %>").text('Some Error Occured. Please Contact to Administrator');
                    }
                    else if (result.d == "2") {
                        $("#<%=lblMsg.ClientID %>").text('Error In Finance Integration Details');
                    }
					 else if (result.d == "5") {
                        $("#<%=lblMsg.ClientID %>").text('Bill Already Generated.');
                    }
                },
                error: function (xhr, status) {
                    var err = eval("(" + xhr.responseText + ")");
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
        function HoldRow(rowid) {

            var row = rowid;
            $("#<%=lblIssueID.ClientID %>").text($(row).closest('tr').find("#tdIssueID").html());
            $("#<%=lblIssuevolumn.ClientID %>").text($(row).closest('tr').find("#tdIssuevolumn").html());
            $("#<%=ltdLedgerTnxID.ClientID %>").text($(row).closest('tr').find("#tdLedgerTnxID").html());
            $("#<%=lblStockID.ClientID %>").text($(row).closest('tr').find("#tdStockID").html());
            var data = new Array();
            var obj = new Object();
            obj.IssueID = $("#<%=lblIssueID.ClientID %>").text();
            obj.StockID = $("#<%=lblStockID.ClientID %>").text();
            data.push(obj);
            $.ajax({
                url: "Services/VenderReturn.asmx/SaveBloodHold",
                data: JSON.stringify({ Data: data }),
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {

                    if (result.d == "1") {
                        BloodReturn();
                        $("#<%=lblMsg.ClientID %>").text('Record Saved Successfully');
                        $("#txtIPDNo").val('');
                        $("#txtRegNo").val('');
                        $("#txtPatientName").val('');

                    }
                },
                error: function (xhr, status) {
                    var err = eval("(" + xhr.responseText + ")");
                    alert(err.Message);
                    window.status = status + "\r\n" + xhr.responseText;

                }

            });
        }
    </script>
    <div id="Pbody_box_inventory">
        <Ajax:ScriptManager ID="ScriptManager1" runat="server">
        </Ajax:ScriptManager>
        <div class="POuter_Box_Inventory" style="text-align: center;">
                <b>Blood Return</b>
                <br />
                <asp:Label ID="lblMsg" runat="server" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center; height: 120px;">
            <div class="Purchaseheader">
                Search Criteria&nbsp;
            </div>
               <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                 Patient Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtPatientName" runat="server" TabIndex="1" ToolTip="Enter Patient Name"
                            MaxLength="50" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                  UHID
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtRegNo" AutoComplete="off" runat="server" TabIndex="2" ToolTip="Enter UHID"
                            MaxLength="20" ClientIDMode="Static"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                IPD No.
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtIPDNo" runat="server" MaxLength="10" TabIndex="3"
                            ToolTip="Enter IPD No." ClientIDMode="Static" />
                            
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:RadioButtonList ID="rdbType" runat="server" TabIndex="4" RepeatDirection="Horizontal" ClientIDMode="Static">
                                  <asp:ListItem Text="All" Value="All" Selected="True"></asp:ListItem>
                                  <asp:ListItem Text="OPD" Value="OPD" ></asp:ListItem>
                                  <asp:ListItem Text="IPD" Value="IPD" ></asp:ListItem>
                                  <asp:ListItem Text="Emer." Value="EMG"></asp:ListItem>
                             </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                 From Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                              <asp:TextBox ID="txtfromdate" runat="server"  ClientIDMode="Static" TabIndex="5"></asp:TextBox>
                        <cc1:CalendarExtender ID="calfromdate" TargetControlID="txtfromdate" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                  To Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                             <asp:TextBox ID="txtdateTo" runat="server" ClientIDMode="Static" TabIndex="6"></asp:TextBox>
                        <cc1:CalendarExtender ID="calTodate" TargetControlID="txtdateTo" Format="dd-MMM-yyyy"
                            Animated="true" runat="server">
                        </cc1:CalendarExtender>
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <asp:Button ID="btnSearch" runat="server" CssClass="margin-top-on-btn" Text="Search" ToolTip="Click To Search"
                OnClick="btnSearch_Click" TabIndex="7"  style="display:none"/>
            <input type="button" id="Search" value="Search" class="save margin-top-on-btn" onclick="BloodReturn();" />
        </div>
          <div class="POuter_Box_Inventory" style="text-align: center;">
              <div id="BloodSearchOutput"></div>
          </div>
        
        <asp:Panel ID="pnlSearch" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 5px; overflow: auto;
                height: 200px">
                <asp:GridView ID="grdSearchList" TabIndex="22"  runat="Server" CssClass="GridViewStyle"
                    OnRowCommand="grdSearchList_RowCommand" AutoGenerateColumns="False" Width="100%">
                    <AlternatingRowStyle CssClass="GridViewAltItemStyle" />
                    <Columns>
                        <asp:TemplateField HeaderText="S.No.">
                            <ItemTemplate>
                                <%# Container.DataItemIndex+1 %>
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="UHID">
                            <ItemTemplate>
                                <asp:Label ID="lblPatientId" runat="server" Text='<%# Eval("MRNo")%>' />
                                <asp:Label ID="lblLedgerTransactionNo" runat="server" Text='<%# Eval("LedgerTransactionNo")%>'
                                    Visible="false" />
                                <asp:Label ID="ltdLedgerTnxID" runat="server" Text='<%# Eval("LedgerTnxID")%>' Visible="false" />
                                <asp:Label ID="lblTransactionid" runat="server" Text='<%# Eval("TransactionID")%>'
                                    Visible="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="IPD No.">
                            <ItemTemplate>
                                <asp:Label ID="lblTransactionID" runat="server" Text='<%# Eval("IPDNo")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Patient Name">
                            <ItemTemplate>
                                <asp:Label ID="lblName" runat="server" Text='<%# Eval("PName")%>' />
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="ItemName" Visible="false">
                            <ItemTemplate>
                                <asp:Label ID="lblItemName" runat="server" Text='<%# Eval("ItemName")%>' />
                                <asp:Label ID="lblitemid" runat="server" Text='<%# Eval("itemid")%>' Visible="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle" />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Component&nbsp;Name">
                            <ItemTemplate>
                                <asp:Label ID="lblComponent" runat="server" Text='<%# Eval("Component")%>' />
                                <asp:Label ID="lblComponentId" runat="server" Text='<%# Eval("ComponentId")%>' Visible="false" />
                                <asp:Label ID="lblBBTubeNo" runat="server" Text='<%# Eval("BBTubeNo")%>' Visible="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" HorizontalAlign="Left" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Expiry Date">
                            <ItemTemplate>
                                <asp:Label ID="lblExpiry" runat="server" Text='<%# Eval("Expiry")%>' />
                                <asp:Label ID="lblIssuevolumn" runat="server" Text='<%# Eval("Issuevolumn")%>' Visible="false" />
                                <asp:Label ID="lblissue_id" runat="server" Text='<%# Eval("issue_id")%>' Visible="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Stock ID">
                            <ItemTemplate>
                                <asp:Label ID="lblStock_ID" runat="server" Text='<%# Eval("Stock_ID")%>' />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Return">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult" runat="server" ImageUrl="../../Images/Post.gif" CommandName="AResult" OnClientClick="return false;ConfirmReturn(e);"
                                    CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Hold" Visible="False">
                            <ItemTemplate>
                                <asp:ImageButton ID="imgResult1" runat="server" ImageUrl="../../Images/Post.gif"
                                    CommandName="AHold" CommandArgument='<%# Container.DataItemIndex %>' CausesValidation="false" />
                            </ItemTemplate>
                            <ItemStyle CssClass="GridViewItemStyle" />
                            <HeaderStyle CssClass="GridViewHeaderStyle"  />
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
        </asp:Panel>
        <asp:Panel ID="pnlTran" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 5px; overflow: auto;
                height: 100px">
                &nbsp;</div>
        </asp:Panel>
        <asp:Panel ID="pnlRequest" runat="server" Visible="false">
            <div class="POuter_Box_Inventory" style="text-align: center; padding-top: 5px; overflow: auto;
                height: 100px">
                <div style="text-align: left; padding-left: 35px;">
                    &nbsp;&nbsp;
                </div>
            </div>
            <div class="POuter_Box_Inventory" style="text-align: center;">
                &nbsp;</div>
        </asp:Panel>
    </div>
    <asp:Label ID="lblIssueID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblIssuevolumn" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="ltdLedgerTnxID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblStockID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblComponentID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblComponentName" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblPatientID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblTransactionID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblItemID" runat="server" Style="display: none"></asp:Label>
    <asp:Label ID="lblBBTubeNo" runat="server" Style="display: none"></asp:Label>
     <asp:Label ID="lblLedgerTransactionNo" runat="server" Style="display: none"></asp:Label>
    <script id="tb_BloodSearch" type="text/html">
    <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdSearch"
    style="width:100%;border-collapse:collapse;">
		<tr>
			<th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:100px;">Type</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;">UHID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">LedgerTransactionNo</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">LedgerTnxID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">ItemName</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">ItemID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;">IPD No.</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:240px;">Patient Name</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:150px;">Component Name</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">ComponentId
			<th class="GridViewHeaderStyle" scope="col" style="width:110px;">Expiry Date</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">Issuevolumn</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px;display:none">issue_id</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:100px; ">Stock ID</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Return</th>
			<th class="GridViewHeaderStyle" scope="col" style="width:80px;">Hold</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">TransactionID</th>
            <th class="GridViewHeaderStyle" scope="col" style="width:80px;display:none">BBTubeNo</th>
            
		</tr>

        <#
       
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
        for(var j=0;j<dataLength;j++)
        {

        objRow = PatientData[j];
        #>
                    <tr id="<#=j+1#>">
              
                

                    <td class="GridViewLabItemStyle"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" id="tdType" style="width:100px;"><#=objRow.TYPE#></td>
                    <td class="GridViewLabItemStyle" id="tdMRNo" style="width:100px;"><#=objRow.MRNo#></td>
                    <td class="GridViewLabItemStyle" id="tdLedgerTransactionNo" style="width:100px;display:none"><#=objRow.LedgerTransactionNo#></td>
                    <td class="GridViewLabItemStyle" id="tdLedgerTnxID" style="width:100px;display:none"><#=objRow.LedgerTnxID#></td>
                    <td class="GridViewLabItemStyle" id="tdItemName" style="width:100px;display:none"><#=objRow.ItemName#></td>
                    <td class="GridViewLabItemStyle" id="tdItemID" style="width:100px;display:none"><#=objRow.itemid#></td>
                    <td class="GridViewLabItemStyle" id="tdIPDNo" style="width:80px;" ><#=objRow.IPDNo#></td>
                    <td class="GridViewLabItemStyle" id="tdPName" align="left" style="width:240px;" ><#=objRow.PName#></td>
                    <td class="GridViewLabItemStyle" id="tdComponentName" align="left" style="width:140px;"><#=objRow.Component#></td>
                    <td class="GridViewLabItemStyle" id="tdComponentID" align="left" style="width:140px;display:none"><#=objRow.ComponentId#></td>
                    <td class="GridViewLabItemStyle" id="tdExpiry" style="width:110px;"><#=objRow.Expiry#></td>
                    <td class="GridViewLabItemStyle" id="tdIssuevolumn" style="width:110px;display:none"><#=objRow.Issuevolumn#></td>
                    <td class="GridViewLabItemStyle" id="tdIssueID" style="width:110px;display:none"><#=objRow.issue_id#></td>
                    <td class="GridViewLabItemStyle" id="tdStockID" style="width:100px;"><#=objRow.Stock_ID#></td>
                    
                    <td class="GridViewLabItemStyle" style="text-align:center;">

                    <img id="imgReturn" src="../../Images/Post.gif" onclick="ConfirmationReturn(this);"  onmouseover="chngcur()" title="Click To Return"
                     />
                         
                    </td>
                        <td class="GridViewLabItemStyle" style="text-align:center;">

                    <img id="imgHold" src="../../Images/Post.gif" onclick="HoldRow(this);"  onmouseover="chngcur()" title="Click To Hold"
                     />
                         
                    </td>
                                         <td class="GridViewLabItemStyle" id="tdTransactionID" style="width:100px;display:none"><#=objRow.TransactionID#></td>
     
                                        <td class="GridViewLabItemStyle" id="tdBBTubeNo" style="width:100px;display:none"><#=objRow.BBTubeNo#></td>

                    
                    
                    
                    </tr>

        <#}#>
        
     </table>    
    </script>
</asp:Content>
