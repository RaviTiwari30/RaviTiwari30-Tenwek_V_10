<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    CodeFile="Create_Batch.aspx.cs" Inherits="Design_CSSD_Create_Batch" EnableEventValidation="false" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<%@ Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="Ajax" %>
<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript"  src="../../Scripts/Search.js"></script>
    <script  src="../../Scripts/jquery.tablednd.js" type="text/javascript"></script>
    <script type="text/javascript" >
        var _PageSize;
        var _PageNo = 0;
        $(document).ready(function () {
            $('#btnAddItem').click(AddItem);
            $('#btnSave').click(SaveData);
        });
        function doClick(buttonName, e) {
            var key;
            if (window.event)
                key = window.event.keyCode;     //IE
            else
                key = e.which;     //firefox
            if (key == 13) {
                var btn = document.getElementById(buttonName);
                if (btn != null) { //If we find the button click it
                    btn.click();
                    event.keyCode = 0
                }
            }
        }

        function MoveUpAndDownText(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == 13) {
                textbox.value = "";
            }
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }

            }
        }

        function MoveUpAndDownValue(textbox2, listbox2) {

            var f = document.theSource;
            var listbox = listbox2;
            var textbox = textbox2;
            if (event.keyCode == '38' || event.keyCode == '40') {
                if (event.keyCode == '40') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m + 1 == listbox.length) {
                                return;
                            }
                            listbox.options[m + 1].selected = true;
                            textbox.value = listbox.options[m + 1].text;

                            return;
                        }
                    }

                    listbox.options[0].selected = true;
                }
                if (event.keyCode == '38') {
                    for (var m = 0; m < listbox.length; m++) {
                        if (listbox.options[m].selected == true) {
                            if (m == 0) {
                                return;
                            }
                            listbox.options[m - 1].selected = true;
                            textbox.value = listbox.options[m - 1].text;
                            return;
                        }
                    }
                }

            }
        }

        function suggestName(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13 && event.keyCode != 8) {
                var listbox = listbox2;
                var textbox = textbox2;
                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                var m
                for (m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].text.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;
                        matched = true;
                        break;
                    }

                }
                if (matched && level < soFar.length) { level++; suggestName(textbox, listbox, level) }
            }

        }
        function suggestValue(textbox2, listbox2, level) {
            if (isNaN(level)) { level = 1 }
            if (event.keyCode != 38 && event.keyCode != 40 && event.keyCode != 13) {
                var f = document.theSource;
                var listbox = listbox2;
                var textbox = textbox2;

                var soFar = textbox.value.toString();
                var soFarLeft = soFar.substring(0, level).toLowerCase();
                var matched = false;
                var suggestion = '';
                for (var m = 0; m < listbox.length; m++) {
                    suggestion = listbox.options[m].value.toString();
                    suggestion = suggestion.substring(0, level).toLowerCase();
                    if (soFarLeft == suggestion) {
                        listbox.options[m].selected = true;

                        matched = true;
                        break;
                    }
                }
                if (matched && level < soFar.length) { level++; suggestName(level) }
            }
        }

    </script>
    <script type="text/javascript">


        function SaveData() {
            var IsReturn = 0;
            $("#<%=lblmsg.ClientID %>").text('');
            $("#tb_grdLabSearch").find("#txtStockQty").each(function () {
                $row = $(this).closest('tr');
                if ($row.find('#chkDataRow').attr("checked")) {
                    var val = $(this).val();
                    while (val.substring(0, 1) == '0') {
                        val = val.substring(1);
                        $("#<%=lblmsg.ClientID %>").text('Please Enter Qty.');
                        $row.find('#txtStockQty').focus();
                        IsReturn = 1;
                        break;
                    }
                    if ($(this).val() == "0") {
                        $("#<%=lblmsg.ClientID %>").text('Please Enter Qty.');
                        IsReturn = 1;
                        $row.find('#txtStockQty').focus();
                        return; ;
                    }
                }

            });

            if (IsReturn == "1") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Qty.');
                return;
            }
            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            var start11 = $("#<%=FrmDate.ClientID %>").val();
            var end11 = $("#<%=ToDate.ClientID %>").val();

            var splitdate11 = start11.split("-");
            var dt111 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];
            var splitdate111 = end11.split("-");
            var dt211 = splitdate111[1] + " " + splitdate111[0] + ", " + splitdate111[2];

            var newStartDate11 = Date.parse(dt111);
            var newEndDate112 = Date.parse(dt211);

            var start_time1 = $('#<%=txtFromTime.ClientID %>').val();
            var end_time1 = $('#<%=txtToTime.ClientID %>').val();
            var stt1 = new Date("November 13, 2013 " + start_time1);
            stt1 = stt1.getTime();
            var endt1 = new Date("November 13, 2013 " + end_time1);
            endt1 = endt1.getTime();
            if ((newStartDate11 + stt1) > (newEndDate112 + endt1)) {
                alert('Approx End Date Time always greater then Start Date Time');
                return;
            }
            

            if ($("#<%=ddlBoilerType.ClientID %>").val() == "0") {
                $("#<%=lblmsg.ClientID %>").text('Please Select Boiler Type');
                $("#<%=ddlBoilerType.ClientID %>").focus();
                IsReturn = 2;
                return;
            }
            if ($.trim($("#<%=txtBatchName.ClientID %>").val()) == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Enter Batch Name');
                $("#<%=txtBatchName.ClientID %>").focus();
                IsReturn = 3;
                return;
            }

            //  TimeCompare();
            //------------------------------------------------------
            $('#btnSave').attr('disabled', true);
            var Itemdata = "";
            $("#tb_grdLabSearch").find("#txtStockQty").each(function () {
                $row = $(this).closest('tr');
                if ($row.find('#chkDataRow').attr("checked")) {
                    if ($(this).val() != 0) {
                        Itemdata += $row.find('#ItemID').text() + '|' + $row.find('#ItemName').text() + '|' + $row.find('#txtStockQty').val() + '|' + $row.find('#IsSet').text() + '|' + $row.find('#SetTnxID').text() + '|' + $row.find('#StockID').text() + '|' + $.trim($("#<%=txtBatchName.ClientID %>").val()) + '|' + $("#<%=ddlBoilerType.ClientID %> option:selected").val() + '|' + $("#<%=ddlBoilerType.ClientID %> option:selected").text() + '|' + $('#<%= FrmDate.ClientID %>').val() + ' ' + $("#<%=txtFromTime.ClientID %>").val() + '|' + $('#<%= ToDate.ClientID %>').val() + ' ' + $("#<%=txtToTime.ClientID %>").val() + '|' + $("#<%=txtRemark.ClientID %>").val();
                        Itemdata = Itemdata + "#"
                    }
                }

            });
            if (Itemdata == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Select Item');
                $("#btnSave").attr('disabled', false);
                IsReturn = 6;
                return;
            }

            if (IsReturn == 0) {
                $.ajax({
                    url: "Services/SetItemStock.asmx/SaveBatchProcessing",
                    data: '{ItemData: "' + Itemdata + '"}', // parameter map
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        if (result.d == "1") {
                            //$('ddlSetItem').find('selected', 'selected')
                            $("#tb_grdLabSearch tr:not(:first)").remove();
                            $("#tb_grdLabSearch").hide();
                            loadData();
                            $("#<%=txtBatchName.ClientID %>").val('');
                            $("#<%=ddlBoilerType.ClientID %> option:selected").val("0");
                            $("#<%=txtRemark.ClientID %>").val('');
                            $("#<%=lblmsg.ClientID %>").text('Record Saved Successfully');                         
                           //$('#BoilerDetail').attr('style', 'display:none');
                            $("#tb_grdLabSearch").show();
                            location.reload();
                        }
                        else {
                            $("#<%=lblmsg.ClientID %>").text('Record Not Saved');
                        }

                        $("#btnSave").attr('disabled', false);
                    },
                    error: function (xhr, status) { 
                        $("#btnSave").attr('disabled', false);
                        window.status = status + "\r\n" + xhr.responseText;
                    }
                });
            }
            else {
                if (Itemdata == "1") {
                    $("#<%=lblmsg.ClientID %>").text('Please Enter Qty.');
                    return;
                }
                else if (Itemdata == "2") {
                    $("#<%=lblmsg.ClientID %>").text('Please Select Boiler Type');
                    return;
                }
                else if (Itemdata == "3") {
                    $("#<%=lblmsg.ClientID %>").text('Please Enter Batch Name');
                    return;
                }
                
                else if (Itemdata == "6") {
                    $("#<%=lblmsg.ClientID %>").text('Please Select Item');
                    return;
                }
                else if (Itemdata == "7") {

                }

            }
        }

        var FirstClick = 0;
        var resultdata;
        var temoporarydata = "";

        function AddItem() {
            var AlreadySelect = 0;
            $("#<%=lblmsg.ClientID %>").text('');
            FirstClick = eval(FirstClick + 1);

            var ItemData = $("#<%=lstBatchItems.ClientID %> option:selected").val();
            if ($("#<%=lstBatchItems.ClientID %> option:selected").text().toUpperCase() == "") {
                $("#<%=lblmsg.ClientID %>").text('Please Select Items');
                return;
            }
            var ItemID = $("#<%=lstBatchItems.ClientID %> option:selected").val();      
            var AlreadySelect = 0;
              $("#tb_grdLabSearch tr").each(function () {
                  var id = $(this).closest("tr").attr("id");
                  if (id != "Header") {
                      if ($.trim($(this).closest("tr").find("#ItemID").text()) == ItemID.split('#')[0]) {
                          AlreadySelect = 1;
                          $("#<%=lblmsg.ClientID %>").text('Item Already Selected');
                          return;
                      }
                  }
              });
            
              if (AlreadySelect == "0") {
                  $("#<%=lblmsg.ClientID %>").text('');
                  $.ajax({
                      url: "Services/SetItemStock.asmx/LoadStockDatanew",
                      data: '{ItemData:"' + ItemData + '"}',
                      type: "POST",
                      contentType: "application/json;charset=utf-8",
                      timeout: 120000,
                      dataType: "json",
                      success: function (result) {
                          PatientData = jQuery.parseJSON(result.d);
                          for (i = 0; i < PatientData.length; i++) {
                              var StockID = PatientData[i].StockID;
                          }
                          RowCount = $("#PatientLabSearchOutput tr").length;
                          RowCount = RowCount + 1;
                          if (RowCount > 2) {
                              /* $("#PatientLabSearchOutput tr").find("#StockID").each(function () {
                              $row = $(this).closest('tr');
                              if ($row.find('#StockID').text() == StockID) {
                              AlreadySelect = 1;
                              alert('Stock Already Added To Table Please select other Item ');
                              return;
                              }
                              });*/

                          }
                          if (AlreadySelect == "0") {
                              var output = $('#tb_PatientLabSearch').parseTemplate(PatientData);
                              $('#PatientLabSearchOutput tr:last').after(output);
                          }
                          //$('#BoilerDetail').attr('style', 'display:""');
                      },
                      error: function (xhr, status) {
                          $("#<%=lblmsg.ClientID %>").text('Error occurred, Please contact administrator');
                          window.status = status + "\r\n" + xhr.responseText;

                      }
                  });
              }
            $('#PatientLabSearchOutput').show();
            $('#divResult').show();
            
        }
        function loadData() {
            $("#<%=lstBatchItems.ClientID %> option").remove();
            var lstBatchItems = $("#<%=lstBatchItems.ClientID %>");
            lstBatchItems.attr("disabled", true);

            $.ajax({
                url: "Services/SetItemStock.asmx/LoadData",
                data: '{}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    PatientData = jQuery.parseJSON(result.d);
                    if (PatientData.length == 0) {
                        lstBatchItems.append($("<option></option>").val("0").html("---No Data Found---"));
                    }
                    else {
                        for (i = 0; i < PatientData.length; i++) {
                            lstBatchItems.append($("<option></option>").val(PatientData[i]["ItemID"]).html(PatientData[i]["ItemName"]));
                        }

                    }
                },
                error: function (xhr, status) {
                    $("#<%=lblmsg.ClientID %>").text('Error has occured Record Not saved');

                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
            lstBatchItems.attr("disabled", false);

        }

        function checkAll(checked) {
            $("#tb_grdLabSearch tr").each(function () {
                $(this).find("#chk").attr("checked", checked.checked);
            });
        }


        function CheckQtyRecive(RecievedQty) {
            var TDSAmt = $(RecievedQty).val();
            while (TDSAmt.substring(0, 1) === '0') {
                TDSAmt = TDSAmt.substring(1);
                $(RecievedQty).val(TDSAmt);
                return;
            }
            if (TDSAmt.match(/[^0-9]/g)) {
                TDSAmt = TDSAmt.replace(/[^0-9]/g, '');
                $(RecievedQty).val(TDSAmt)
                return;
            }
            if (eval($(RecievedQty).val()) > eval($(RecievedQty).closest('tr').find('#StockQty').text())) {
                alert('Received Quantity cannot greater than Stock Quantity');
                $(RecievedQty).val("0");
                return;
            }
        }
        function checkAll(checkbox) {
            $("#tb_grdLabSearch tr").each(function () {
                $(this).find("#chkDataRow").attr("checked", checkbox.checked);
            });
        }

        function ShowStock(btnshowstock) {


            $row = $(btnshowstock).closest('tr');
            var StockID = $row.find('#ItemID').text();
            var SetStockID = $row.find('#SetStockID').text();
            $.ajax({
                url: "Services/SetItemStock.asmx/LoadStockDataSetNew",
                data: '{setID:"' + StockID + '",SetStockID:"' + SetStockID + '"}',
                type: "POST",
                contentType: "application/json;charset=utf-8",
                timeout: 120000,
                dataType: "json",
                success: function (result) {
                    temoporarydata = jQuery.parseJSON(result.d);

                    OpenPopHTML(temoporarydata);
                },
                error: function (xhr, status) {
                    $("#<%=lblmsg.ClientID %>").text('Error has occured');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }



        function OpenPopHTML(Data) {

            $("#div_InvestigationItems").empty(table);

            var table = "<table id='tblResult' cellspacing='0' rules='all' border='1' class='GridViewStyle'><tr class='GridViewLabItemStyle'> <th class='GridViewHeaderStyle' style='width:20px; ' scope='col'>S.No.</th> <th class='GridViewHeaderStyle' style='width:380px;'>Item Name</th>  <th class='GridViewHeaderStyle' style='width:30px;' scope='col'>Quantity</th>  </tr><tbody>";

            for (var i = 0; i < Data.length; i++) {


                var row = "<tr class='GridViewLabItemStyle'>";
                row += "<td class='GridViewLabItemStyle' style='width:20px; '>" + (i + 1) + "</td>";
                row += "<td class='GridViewLabItemStyle' style='width:380px;'>" + Data[i].ItemName + "</td>";
                row += "<td class='GridViewLabItemStyle' style='width:30px;'>" + Data[i].SetQuantity + "</td>";
                row += "</tr>";
                table += row;
            }

            table += "</tbody></table>";

            $("#div_InvestigationItems").append(table);

            $find("modalInves").show();



        }
        $(document).ready(function () {
            $("#<%=txtToTime.ClientID %>,#<%=txtFromTime.ClientID %>").change(function () {
                //start time
                var start_time = $('#<%=txtFromTime.ClientID %>').val();

                //end time
                var end_time = $('#<%=txtToTime.ClientID %>').val();
                var stt = new Date("November 13, 2013 " + start_time);
                stt = stt.getTime();

                var endt = new Date("November 13, 2013 " + end_time);
                endt = endt.getTime();

                if (stt > endt) {
                    alert('Approx End-time always greater then Start-time');
                    return false;
                }


            });

        });
        function TimeCompare() {
            var a = 0;
            var start_time = $('#<%=txtFromTime.ClientID %>').val();
            var end_time = $('#<%=txtToTime.ClientID %>').val();
            var stt = new Date("November 13, 2013 " + start_time);
            stt = stt.getTime();
            var endt = new Date("November 13, 2013 " + end_time);
            endt = endt.getTime();
            if (stt > endt) {
                alert('Approx End-time always greater then Start-time');
                return;
            }

        }
        function ValidateDate() {
            var start1 = $("#<%=FrmDate.ClientID %>").val();
            var end1 = $("#<%=ToDate.ClientID %>").val();

            var splitdate1 = start1.split("-");
            var dt11 = splitdate1[1] + " " + splitdate1[0] + ", " + splitdate1[2];
            var splitdate11 = end1.split("-");
            var dt21 = splitdate11[1] + " " + splitdate11[0] + ", " + splitdate11[2];

            var newStartDate1 = Date.parse(dt11);
            var newEndDate1 = Date.parse(dt21);

            if (newStartDate1 > newEndDate1) {
                alert("Approx Of End Date should be greater than Start Date");
                $("#<%=ToDate.ClientID %>").focus();
                return;
            }
        }
        function pageLoad(sender, args) {
            if (!args.get_isPartialLoad()) {
                $addHandler(document, "keydown", onKeyDown);
            }
        }
        function onKeyDown(e) {
            if (e && e.keyCode == Sys.UI.Key.esc) {
                if ($find("modalInves")) {
                    $find("modalInves").hide();

                }
            }
        }
        function validatespace() {
            var Name = $("#<%=txtBatchName.ClientID %>").val();
            if (Name.charAt(0) == ' ' || Name.charAt(0) == '.' || Name.charAt(0) == ',' || Name.charAt(0) == '0' || Name.charAt(0) == "'" || Name.charAt(0) == '-') {
                $("#<%=txtBatchName.ClientID %>").val('');
                $('#<%=lblmsg.ClientID %>').text('First Character Cannot Be Space/Dot');
                Name.replace(Name.charAt(0), "");
                return false;
            }

            else {
                $('#<%=lblmsg.ClientID %>').text('');
                return true;
            }

        }
        function check(e) {
            var keynum
            var keychar
            var numcheck
            // For Internet Explorer  
            if (window.event) {
                keynum = e.keyCode
            }
            // For Netscape/Firefox/Opera  
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)

            //List of special characters you want to restrict
            if (keychar == "#" || keychar == "`" || keychar == "!" || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "43") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "37") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }

            else {
                return true;
            }
        }
    </script>
    <Ajax:ScriptManager ID="ScriptManager1" runat="server">
    </Ajax:ScriptManager>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            <b>Process Sets in Batch</b><br />
            <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError">
            </asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Search by Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:TextBox ID="txtSearch" runat="server" Width="217px" onKeyDown="MoveUpAndDownText(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstBatchItems);"
                                onkeyup="suggestName(ctl00$ContentPlaceHolder1$txtSearch,ctl00$ContentPlaceHolder1$lstBatchItems);" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Set & Item List
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-10">
                            <asp:ListBox ID="lstBatchItems" TabIndex="4" runat="server" Width="500px" Height="150px"
                                ToolTip="Select Items"></asp:ListBox>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" value="Add Item" id="btnAddItem" title="Click To Add Items"
                                class="ItDoseButton" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
            <table cellpadding="0" cellspacing="0" style="width: 100%">
                <tr>
                    <td colspan="5">
                        <div class="content" id="PatientLabSearchOutput" style="max-height: 400px; overflow-y: auto; overflow-x: auto;width: 100%; display:none;">
                            <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch"
                                style="width: 100%; border-collapse: collapse;">
                                <tr id="Header">
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px;">
                                        <input type="checkbox" onclick="checkAll(this);" id="chkHeader" style="display: none" />
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none">S.No.
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none;">Item ID
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none;">Set StockID
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 10px; display: none;">StockID
                                    </th>

                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20%;">Item/Set Name
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20%; display: none;">From Dept.
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20%;">Qty. In Stock
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20%;">Qty. In Batch
                                    </th>
                                    <th class="GridViewHeaderStyle" scope="col" style="width: 20%;"></th>
                                </tr>
                            </table>
                        </div>
                    </td>
                </tr>

            </table>
        </div>
        <div class="POuter_Box_Inventory" id="divResult" style="display:none;">
            <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Approx Start Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="FrmDate" runat="server" ToolTip="Enter Approx Start Date"></asp:TextBox>
                            <cc1:CalendarExtender ID="calFrmDate" runat="server" TargetControlID="FrmDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtFromTime" runat="server" MaxLength="5" ToolTip="Enter Approx Start Time"></asp:TextBox>&nbsp;&nbsp;&nbsp;
                            <cc1:MaskedEditExtender ID="masTime" Mask="99:99" runat="server" MaskType="Time"
                                TargetControlID="txtFromTime" AcceptAMPM="True">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTime" runat="server" ControlToValidate="txtFromTime"
                                ControlExtender="masTime" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Approx End Date
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-3">
                            <asp:TextBox ID="ToDate" runat="server" ToolTip="Enter Approx End Date"
                                onchange="javascript:ValidateDate();"></asp:TextBox>
                            <cc1:CalendarExtender ID="calToDate" runat="server" TargetControlID="ToDate" Format="dd-MMM-yyyy">
                            </cc1:CalendarExtender>
                        </div>
                        <div class="col-md-2">
                            <asp:TextBox ID="txtToTime" ToolTip="Enter Approx End Time" runat="server"
                                MaxLength="5"></asp:TextBox>
                            <cc1:MaskedEditExtender ID="masTo" Mask="99:99" runat="server" MaskType="Time" TargetControlID="txtToTime"
                                AcceptAMPM="True">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="maskTo" runat="server" ControlToValidate="txtToTime"
                                ControlExtender="masTo" IsValidEmpty="true" EmptyValueMessage="Time Required"
                                InvalidValueMessage="Invalid Time" ValidationGroup="save1"></cc1:MaskedEditValidator>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Boiler Type
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:DropDownList ID="ddlBoilerType" ToolTip="Select Boiler Type" runat="server">
                                <asp:ListItem Selected="True" Value="0">Select</asp:ListItem>
                                <asp:ListItem Value="1">Low Temperature Machine</asp:ListItem>
                                <asp:ListItem Value="2">Steam Temperature (S-1000)</asp:ListItem>
                                <asp:ListItem Value="2">Steam Temperature (S-500)</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">
                                Batch Name
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtBatchName" CssClass="requiredField" ToolTip="Enter Batch Name" runat="server" MaxLength="20"
                                onkeypress="return check(event)" onkeyup="validatespace();"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                                Remark
                            </label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:TextBox ID="txtRemark" ToolTip="Enter Remark" runat="server" MaxLength="100"
                                onkeypress="return check(event)"></asp:TextBox>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">
                            </label>
                            <b class="pull-right"></b>
                        </div>
                        <div class="col-md-5">
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-11">
                        </div>
                        <div class="col-md-2">
                            <input type="button" value="Save" class="ItDoseButton" id="btnSave" title="Click To Save"
                                validationgroup="save1" />
                        </div>
                        <div class="col-md-11">
                        </div>
                    </div>
                </div>
                <div class="col-md-1"></div>
            </div>
        </div>
        <cc1:ModalPopupExtender ID="modalInves" runat="server" DropShadow="false" TargetControlID="Button1"
            BackgroundCssClass="filterPupupBackground" PopupControlID="PnlInvestigation"
            CancelControlID="imgCloseButton" X="300" Y="140" BehaviorID="modalInves">
        </cc1:ModalPopupExtender>
        <asp:Button ID="Button1" Style="display: none;" runat="server" CssClass="ItDoseButton"/>
        <asp:Panel ID="PnlInvestigation" runat="server" Style="display: none;" CssClass="pnlVendorItemsFilter">
            <div id="Div1" runat="server" class="Purchaseheader">
                <b>Set Details </b>&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp; &nbsp; &nbsp;&nbsp; &nbsp;
                &nbsp;&nbsp; &nbsp;<em ><span style="font-size: 7.5pt"> Press esc or click
                <asp:ImageButton ID="imgCloseButton" runat="server" ClientIDMode="Static" ImageUrl="~/Images/Delete.gif" />
                to close</span></em>
            </div>
            <table>
                <tr>
                    <td>
                        <div id="div_InvestigationItems" style="overflow: auto; max-height: 250px;">
                        </div>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </div>
    <script id="tb_PatientLabSearch" type="text/html">
        <#
        var dataLength=PatientData.length;
        window.status="Total Records Found :"+ dataLength;
        var objRow;   
        var status;
         for(var j=0;j<dataLength;j++)
        {
        objRow = PatientData[j];
        #>
                    <tr id="<#=objRow.stockid#>">
                    <td  class="GridViewLabItemStyle"><input type="checkbox" checked="checked" id="chkDataRow"  /></td>
                    <td class="GridViewLabItemStyle" style="display:none"><#=j+1#></td>
                    <td class="GridViewLabItemStyle" style="display:none" id="IsSet"><#=objRow.IsSet#></td>
                     <td class="GridViewLabItemStyle" style="display:none"  id="SetTnxID"><#=objRow.SetTnxID#></td>
                     <td class="GridViewLabItemStyle" style="display:none" id="StockID"><#=objRow.StockID#></td>
                    <td class="GridViewLabItemStyle" style="display:none" id="ItemID"><#=objRow.ItemID#></td>
                    <td class="GridViewLabItemStyle" style="display:none" id="SetStockID"><#=objRow.SetStockID#></td>
                    <td class="GridViewLabItemStyle" id="ItemName"><#=objRow.ItemName#></td>
                     <td class="GridViewLabItemStyle" style="display:none" id="FromDept"><#=objRow.FromDept#></td>
                    <td class="GridViewLabItemStyle" id="StockQty" style="text-align:right"><#=objRow.Qty#></td>
                    <td class="GridViewLabItemStyle" style="text-align:right">
                         <#if(objRow.IsSet==1){#>
                         <input type="text" value="<#=objRow.Qty#>" class="ItDoseTextinputNum" id="txtStockQty" size="3" onkeyup="CheckQtyRecive(this);" disabled="disabled" />
                         <#}else{#>
                         <input type="text" value="0" id="txtStockQty" class="ItDoseTextinputNum" size="3" title="Enter Batch Qty." onkeyup="CheckQtyRecive(this);"/>
                         <#}#>
                   </td>
                    <td class="GridViewLabItemStyle" >
                         <#if(objRow.IsSet==1){#>
                         <input type="button" value="Show Set Items"  class="ItDoseButton" id="showsetBtn"  onclick="ShowStock(this);" />
                         <#}#>
                   </td>
                    </tr>
        <#}#>
    </script>
</asp:Content>
