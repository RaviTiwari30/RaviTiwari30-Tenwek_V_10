<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true" CodeFile="Premade_Reply_master.aspx.cs" Inherits="Premade_Reply_master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script src="../../Scripts/jquery.extensions.js" type="text/javascript"></script>
    <script type="text/javascript" src="../../Scripts/Message.js"></script>

    <script type="text/javascript">
        $(document).ready(function () {
            $("#txtTitle").focus();
            premadeSearch();
        });

        function premadeSearch() {
            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/premadeSearch",
                data: '{}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    premade = jQuery.parseJSON(response.d);
                    if (premade != null && response.d != "") {
                        var output = $('#tb_SearchPreType').parseTemplate(premade);
                        $('#PreMadeOutput').html(output);
                        $('#PreMadeOutput').show();
                    }
                    else {
                        $('#PreMadeOutput').html("").hide();
                    }
                },
                error: function (xhr, status) {
                    DisplayMsg('MM05', 'lblErrormsg');
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }

        function savePreMade() {
            $("#btnSave").val("Submitting...").attr("disabled", "disabled");

            if ($.trim($("#txtTitle").val()) == "") {
                $("#lblErrormsg").text('Please Enter Title');
                $("#txtTitle").focus();
                $("#btnSave").val("Save").removeAttr("disabled");
                return;
            }

            if ($.trim($("#txtDescription").val()) == "") {
                $("#lblErrormsg").text('Please Enter Description');
                $("#txtDescription").focus();
                $("#btnSave").val("Save").removeAttr("disabled");
                return;
            }

            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/savePreMade",
                data: '{Title:"' + $.trim($("#txtTitle").val()) + '",Status:"' + $.trim($("#<%=rbtnStatus.ClientID%> input[type:radio]:checked").val()) + '",Description:"' + $.trim($("#txtDescription").val()) + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    if (response.d == "2") {
                        $("#lblErrormsg").text("Title Already Exist");
                        $("#btnSave").val("Save").removeAttr("disabled");
                    }
                    else if (response.d == "1") {
                        premadeSearch();
                        cancelPreMade();
                        DisplayMsg('MM01', 'lblErrormsg');
                        $("#btnSave").removeAttr("disabled");
                    }
                    else {
                        DisplayMsg('MM07', 'lblErrormsg');
                        $("#btnSave").val("Save").removeAttr("disabled");
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    DisplayMsg('MM05', 'lblErrormsg');
                    $("#btnSave").val("Save").removeAttr("disabled");
                }
            });
        }

        function updatePreMade(preMadeID) {
            $("#btnSave").val("Submitting...").attr("disabled", "disabled");

            if ($.trim($("#txtTitle").val()) == "") {
                $("#btnSave").val("Update").removeAttr("disabled");
                $("#lblErrormsg").text('Please Enter Title');
                $("#txtTitle").focus();
                return;
            }
            if ($.trim($("#txtDescription").val()) == "") {
                $("#btnSave").val("Update").removeAttr("disabled");
                $("#lblErrormsg").text('Please Enter Description');
                $("#txtDescription").focus();
                return;
            }

            $.ajax({
                type: "POST",
                url: "Services/HelpDesk.asmx/updatePreMade",
                data: '{Title:"' + $.trim($("#txtTitle").val()) + '",Status:"' + $("#<%=rbtnStatus.ClientID%> input[type:radio]:checked").val() + '",Description:"' + $("#txtDescription").val() + '",PreMadeID:"' + $("#spnID").text() + '"}',
                dataType: "json",
                contentType: "application/json;charset=UTF-8",
                async: false,
                success: function (response) {
                    if (response.d == "2") {
                        $("#lblErrormsg").text("Title Already Exist");
                        $("#btnSave").val("Update").removeAttr("disabled");
                    }
                    else if (response.d == "1") {
                        premadeSearch();
                        cancelPreMade();
                        DisplayMsg('MM02', 'lblErrormsg');
                        $("#btnSave").removeAttr("disabled");
                    }
                    else {
                        DisplayMsg('MM124', 'lblErrormsg');
                        $("#btnSave").val("Update").removeAttr("disabled");
                    }
                },
                error: function (xhr, status) {
                    window.status = status + "\r\n" + xhr.responseText;
                    DisplayMsg('MM05', 'lblErrormsg');
                    $("#btnSave").val("Update").removeAttr("disabled");
                }
            });
        }

        function PreMadeTypeCon() {
            if ($("#btnSave").val() == "Save") {                
                savePreMade();                
            }
            else {                
                updatePreMade();                
            }
        }

        function editPreMadeType(rowid) {
            var title = $(rowid).closest('tr').find('#tdTitle').text();
            var id = $(rowid).closest('tr').find('#tdpreMadeID').text();
            if ($(rowid).closest('tr').find('#tdStatus').text() == "Active") {
                $("#<%=rbtnStatus.ClientID%>").find('input:radio[value=1]').prop('checked', true);
            }
            else {
                $("#<%=rbtnStatus.ClientID%>").find('input:radio[value=0]').prop('checked', true);
            }
            var Description = $(rowid).closest('tr').find('#tdDescription').text();

            $("#txtTitle").val(title);
            $("#spnID").text(id);
            $("#txtDescription").val(Description);
            $("#btnSave").val('Update');
            $("#btnCancel").show();
            $("#lblremaingCharacters").html(500 - ($("#txtDescription").val().length));
        }

        function cancelPreMade() {
            $("#btnSave").val('Save');
            $("#btnCancel").hide();
            $("#txtTitle").val('');
            $("#spnID").text('');
            $("#txtDescription").val('');
            $("#<%=rbtnStatus.ClientID%>").find('input:radio[value=1]').prop('checked', true);
            $("#lblremaingCharacters").html(500 - ($("#txtDescription").val().length));
        }

        $(document).ready(function () {
            $("#txtTitle").focus();
            var MaxLength = 500;
            $("#lblremaingCharacters").html(MaxLength - ($("#txtDescription").val().length));
            $('textarea[maxlength]').bind("keyup keydown", function (e) {
                var limit = parseInt($(this).attr('maxlength'));
                var text = $(this).val();
                var chars = text.length;
                $("#lblErrormsg").text("");
                if (chars > limit) {
                    $("#lblErrormsg").text("You cannot enter more than " + limit + " characters.");
                    var new_text = text.substr(0, limit);
                    $(this).val(new_text);
                }
                var characterInserted = $(this).val().length;
                if (characterInserted > MaxLength) {
                    $(this).val($(this).val().substr(0, MaxLength));
                }
                var characterRemaining = MaxLength - characterInserted;
                $("#lblremaingCharacters").html(characterRemaining);
            });

            $("#txtDescription").bind("cut copy paste", function (event) {
                event.preventDefault();
            });
        });

        function check(sender, e) {
            var keynum
            var keychar
            var numcheck
            if (window.event) {
                keynum = e.keyCode
            }
            else if (e.which) {
                keynum = e.which
            }
            keychar = String.fromCharCode(keynum)
            formatBox = document.getElementById(sender.id);
            strLen = sender.value.length;
            strVal = sender.value;
            hasDec = false;
            e = (e) ? e : (window.event) ? event : null;
            if (e) {
                var charCode = (e.charCode) ? e.charCode :
                            ((e.keyCode) ? e.keyCode :
                            ((e.which) ? e.which : 0));
                if ((charCode == 45)) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '-');
                        if (hasDec)
                            return false;
                    }
                }
                if (charCode == 46) {
                    for (var i = 0; i < strLen; i++) {
                        hasDec = (strVal.charAt(i) == '.');
                        if (hasDec)
                            return false;
                    }
                }
            }
            //List of special characters you want to restrict
            if (keychar == "`" || keychar == "!" || keychar == "," || keychar == "~" || keychar == ";" || keychar == "/" || (keynum >= "40" && keynum <= "44") || (keynum >= "91" && keynum <= "95") || (keynum >= "58" && keynum <= "64") || (keynum >= "34" && keynum <= "38") || (keynum >= "123" && keynum <= "125")) {
                return false;
            }
            else {
                return true;
            }
        }

        function validatespace() {
            var Title = $('#txtTitle').val();
            if (Title.charAt(0) == ' ' || Title.charAt(0) == '.') {
                $('#txtTitle').val('');
                $('#lblErrormsg').text('First Character Cannot Be Space/Dot');
                Title.replace(Title.charAt(0), "");
                return false;
            }
            else {
                $('#lblErrormsg').text('');
                return true;
            }
        }
    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center">
            <b>PreMade Reply</b><br />
            <asp:Label ID="lblErrormsg" runat="server" ClientIDMode="Static" CssClass="ItDoseLblError"></asp:Label>
        </div>
        <div class="POuter_Box_Inventory">
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                    <div class="row">
                        <div class="col-md-3">
                            <label class="pull-left">Title</label><b class="pull-right">:</b></div>
                        <div class="col-md-5">
                            <input type="text" maxlength="50" tabindex="1" id="txtTitle" onkeypress="return check(this,event)" onkeyup="validatespace();" title="Enter Title" class="requiredField"/>
                            <span id="spnID" style="display:none;"></span>
                        </div>
                        <div class="col-md-3"><label class="pull-left">Status</label>
                            <b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <asp:RadioButtonList ID="rbtnStatus" runat="server" RepeatDirection="Horizontal" TabIndex="2">
                            <asp:ListItem Selected="True" Value="1">Active</asp:ListItem>
                            <asp:ListItem Value="0">InActive</asp:ListItem>
                        </asp:RadioButtonList>
                        </div>
                        <div class="col-md-3">
                            <label class="pull-left">Description</label><b class="pull-right">:</b>
                        </div>
                        <div class="col-md-5">
                            <textarea style="height: 55px; Width: 290px" id="txtDescription" maxlength='500' tabindex="3" onkeypress="return check(this,event)" title="Enter Description"></textarea>
                        <span style="color: Red; font-size: 10px;">*</span>
                        Number of Characters Left:<asp:Label runat="server" ClientIDMode="Static" ID="lblremaingCharacters" Style="background-color: #E2EEF1; color: Red; font-weight: bold;"></asp:Label>
                        </div>
                    </div></div><div class="col-md-1"></div></div></div>
            <div style="text-align:center" class="POuter_Box_Inventory">
                <input type="button" id="btnSave" value="Save" class="ItDoseButton" onclick="PreMadeTypeCon()" tabindex="4" title="Click To Submit"/>
                        <input type="button" id="btnCancel" value="Cancel" tabindex="5" class="ItDoseButton" style="display: none" onclick="cancelPreMade()" title="Click To Cancel"/>
            </div> 
        <div style="text-align:center" class="POuter_Box_Inventory">
            <table border="0" style="width: 100%">
                <tr>
                    <td colspan="3" style="text-align: center">
                        <div id="PreMadeOutput" style="max-height: 600px; overflow-x: auto;"></div>
                        <br />
                    </td>
                </tr>
            </table>
       </div>
    </div>

    <script id="tb_SearchPreType" type="text/html">
        <table class="FixedTables" cellspacing="0" rules="all" border="1" id="tb_grdPreMadeType" style="width:100%;border-collapse:collapse;">
            <tr id="Header">
			    <th class="GridViewHeaderStyle" scope="col" style="width:10px;">S.No.</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:140px;">Title</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:70px;">Status</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:340px;">Description</th>
                <th class="GridViewHeaderStyle" scope="col" style="width:160px;">Create Date</th>	
                <th class="GridViewHeaderStyle" scope="col" style="width:60px; display:none ">ID</th>		          
                <th class="GridViewHeaderStyle" scope="col" style="width:30px;">Edit</th>           
            </tr>
            <#       
                var dataLength=premade.length;
                window.status="Total Records Found :"+ dataLength;
                var objRow;   
                for(var j=0;j<dataLength;j++)
                {       
                    objRow = premade[j];
            #>
            <tr id="<#=j+1#>">                            
                <td class="GridViewLabItemStyle" style="width:10px;"><#=j+1#></td>
                <td class="GridViewLabItemStyle" id="tdTitle"  style="width:140px;text-align:center" ><#=objRow.Title#></td>
                <td class="GridViewLabItemStyle" id="tdStatus"  style="width:70px;" ><#=objRow.Status#></td>
                <td class="GridViewLabItemStyle" id="tdDescription"  style="width:340px;" ><#=objRow.Description#></td>
                <td class="GridViewLabItemStyle" id="tdLast_Update"  style="width:160px;" ><#=objRow.Last_Update#></td>
                <td class="GridViewLabItemStyle" id="tdpreMadeID" style="width:60px;display:none"><#=objRow.ID#></td>
                <td class="GridViewLabItemStyle" style="width:30px; text-align:right">
                    <input type="button" value="Edit" id="btnEdit" class="ItDoseButton" onclick="editPreMadeType(this);" title="Click To Edit"/>                                                    
                </td>                    
            </tr>            
            <#}#>      
        </table>    
    </script>
</asp:Content>

