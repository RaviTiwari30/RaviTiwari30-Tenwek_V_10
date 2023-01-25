<%@ Page Language="C#" MasterPageFile="~/DefaultHome.master" AutoEventWireup="true"
    EnableEventValidation="false" CodeFile="DocGroupRateMaster.aspx.cs" Inherits="Design_Doctor_DocGroupRateMaster" %>

<asp:Content ID="Content1" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {

            if ($('#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked').val() == 'OPD' || $('#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked').val() == 'IPD') {
                if ($("select[id$=ddlPanel]").val() != "0") {
                    $("#btnSave").removeAttr('disabled');

                }
                else {
                    $("#btnSave").attr('disabled', 'disabled');

                }
            }
            $('#ddlPanel').change(function () {
                if ($("select[id$=ddlPanel]").val() != "0") {
                    $("#btnSave").removeAttr('disabled');

                }
                else {
                    $("#btnSave").attr('disabled', 'disabled');

                }
            });
            $('#<%=rdoOPDIPD.ClientID%>').change(function () {
                if ($('#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked').val() == 'OPD' || $('#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked').val() == 'IPD') {
                    if ($("select[id$=ddlPanel]").val() != "0") {
                        $("#btnSave").removeAttr('disabled');

                    }
                    else {
                        $("#btnSave").attr('disabled', 'disabled');

                    }
                }
            });


            $("#<%=rdoOPDIPD.ClientID%>").click(function () {
                clearform();
                var type = $("#<%=rdoOPDIPD.ClientID%> input[type=radio]:checked").val();
                $("#<%=ddlPanel.ClientID%> option").remove();
                $.ajax({

                    url: "../Doctor/Services/DocGrouprateMaster.asmx/bindDocPanel",
                    data: '{ Type: "' + type + '"}',
                    type: "POST", // data has to be Posted    	        
                    contentType: "application/json; charset=utf-8",
                    timeout: 120000,
                    dataType: "json",
                    success: function (result) {
                        panelData = jQuery.parseJSON(result.d);
                        if (panelData.length == 0) {
                            $("#<%=ddlPanel.ClientID%>").append($("<option></option>").val("0").html("---No Data Found---"));
                        }
                        else {
                            $("#<%=ddlPanel.ClientID%>").append($("<option></option>").val("0").html("Select"));
                            for (i = 0; i < panelData.length; i++) {
                                $("#<%=ddlPanel.ClientID%>").append($("<option></option>").val(panelData[i].PanelID).html(panelData[i].Company_Name));
                            }

                        }
                    },
                    error: function (xhr, status) {
                        alert("Error occurred, Please contact administrator");

                        window.status = status + "\r\n" + xhr.responseText;
                    }

                });
            });
        });
        function GetData() {
            if ($("#<%=ddlPanel.ClientID %>").val() == '0') {
                alert("Please select Panel");
                if ($("select[id$=ddlPanel]").val() != "0") {
                    $("#btnSave").removeAttr('disabled');
                }
                else {
                    $("#tb_grdLabSearch tr").attr('style', 'display:none');
                    $("#btnSave").attr('disabled', 'disabled');
                }
                return;
            }
            $("input,select").attr('disabled', true);
            $.ajax({
                url: "../Doctor/Services/DocGrouprateMaster.asmx/SearchDocData",
                data: '{ Type: "' + $("#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked").val() + '",PanelID: "' + $("#<%=ddlPanel.ClientID %>").val() + '"}',
            type: "POST",
            contentType: "application/json; charset=utf-8",
            timeout: 120000,
            dataType: "json",
            success: function (result) {
                DocData = jQuery.parseJSON(result.d);
                if (DocData.length > 0) {
                    var output = $('#tb_InvestigationItems').parseTemplate(DocData);
                    $('#div_InvestigationItems').html(output);
                    $("#tb_grdLabSearch tr").find('td:last').attr('style', 'display:none');
                    $("#tb_grdLabSearch tr").find('th:last').attr('style', 'display:none');
                    if ($("#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked").val() == 'IPD') {
                            $("#tb_grdLabSearch tr").find('td:eq(2)').attr('style', 'display:none');
                            $("#tb_grdLabSearch tr").find('th:eq(2)').attr('style', 'display:none');
                        }
                    }
                    else
                        alert("Record Not found");

                    $("input,select").attr('disabled', false);

                },
            error: function (xhr, status) {
                alert("Error occurred, Please contact administrator");
                $("input,select").attr('disabled', false);
                window.status = status + "\r\n" + xhr.responseText;
            }
        });
        }
        function applytoall() {
            var UserId = '<%= Session["ID"].ToString() %>';
            $.ajax({
                url: "../Doctor/Services/DocGrouprateMaster.asmx/SaveDocDataAll",
                data: '{ UserId: "' + UserId + '",Type: "' + $("#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked").val() + '"}', // parameter map
                type: "POST",
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                dataType: "json",
                async: false,
                success: function (result) {
                    if (result > "1") {


                    }
                    else {
                        alert("Record Not Saved");

                    }

                    $("input,select").attr('disabled', false);
                },
                error: function (xhr, status) {
                    alert("Error occurred, Please contact administrator");
                    $("input,select").attr('disabled', false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });
        }
        function SaveData() {

            if ($("#<%=ddlPanel.ClientID %>").val() == '0') {
                alert("Please Select Panel");
                $("#<%=ddlPanel.ClientID %>").focus();
                return;
            }

            var Docdata = "";
            $("#tb_grdLabSearch tr").each(function () {
                if ($(this).attr('id') == 'Header') {
                    $(this).find('th').each(function () {
                        if ($(this).attr('id') != 'tdSno')
                            Docdata += $(this).text() + '|';
                    });
                }
                else {
                    $(this).find('td').each(function () {
                        if ($(this).attr('id') != 'tdSno')
                            Docdata += $(this).find("#txt").val() + '|';
                    });
                }
                Docdata += '$';
            });

            if (Docdata == "") {
                alert("Error occurred, Please contact administrator");
                return;
            }
            $("input,select").attr('disabled', true);
            $.ajax({

                url: "../Doctor/Services/DocGrouprateMaster.asmx/SaveDocData",
                data: '{ Docdata: "' + Docdata + '",Panelid:"' + $("#<%=ddlPanel.ClientID %>").val() + '",Type: "' + $("#<%=rdoOPDIPD.ClientID %> input[type=radio]:checked").val() + '"}', // parameter map
                type: "POST", // data has to be Posted    	        
                contentType: "application/json; charset=utf-8",
                timeout: 120000,
                async: false,
                dataType: "json",
                success: function (result) {
                    if (result > "1") {
                        if ($('#<%= chkAll.ClientID %>').is(':checked')) {
                            applytoall();
                        }
                        alert("Record Saved Successfully");
                        clearform();

                    }
                    else {
                        alert("Record Not Saved");

                    }

                    $("input,select").attr('disabled', false);
                },
                error: function (xhr, status) {
                    alert("Error occurred, Please contact administrator");
                    $("input,select").attr('disabled', false);
                    window.status = status + "\r\n" + xhr.responseText;
                }
            });



        }

        function clearform() {
            $(':text, textarea').val('');
            $('select[id$=ddlPanel] option:nth-child(1)').attr('selected', 'selected')
            $(":checkbox").attr('checked', false);
            $("#tb_grdLabSearch tr").remove();
        }


    </script>
    <div id="Pbody_box_inventory">
        <div class="POuter_Box_Inventory" style="text-align: center;">
            
                <span style="font-size: 12pt"><b style="font-size: small">Doctor Group Rate Master</b><br />
                    
                    <asp:Label ID="lblmsg" runat="server" CssClass="ItDoseLblError" ></asp:Label></span>
        </div>
        <div class="POuter_Box_Inventory">
            <div class="Purchaseheader">
                Doctor Group
            </div>
              <div class="row">
                <div class="col-md-1"></div>
                <div class="col-md-22">
                       <div class="row">
                        <div class="col-md-4">
                            <label class="pull-left">
                                 <asp:RadioButtonList ID="rdoOPDIPD"  runat="server" RepeatDirection="Horizontal" ToolTip="Select IPD Or OPD To Update Doctor Group" OnSelectedIndexChanged="rdoOPDIPD_SelectedIndexChanged" AutoPostBack="false">
                            <asp:ListItem Text="OPD" Value="OPD" Selected="True"></asp:ListItem>
                            <asp:ListItem Text="IPD" Value="IPD"></asp:ListItem>
                        </asp:RadioButtonList>
                            </label>
                        </div>
                        <div class="col-md-5">
                             <asp:DropDownList ID="ddlPanel" runat="server"
                            onchange="GetData()" ToolTip="Select panel">
                        </asp:DropDownList>
                        </div>
                           <div class="col-md-15">
                                <div id="div_InvestigationItems" style="overflow: auto; max-height: 500px;">
            </div>
                           </div>
                    </div>
                     </div>
                <div class="col-md-1"></div>
            </div>
           
        </div>
        <script id="tb_InvestigationItems" type="text/html">
        <table class="GridViewStyle" cellspacing="0" rules="all" border="1" id="tb_grdLabSearch" style="border-collapse:collapse;">
		
  <tr id="Header" >
<th id="tdSno" class="GridViewHeaderStyle" scope="col" style="width:20px;">S.No.</th>
       <#
       
        for(var i in DocData[0])
        {
           if(i!='SubCategoryID')
           #>
          
			<th class="GridViewHeaderStyle" scope="col" style="text-align:center;"><#=i#></th>
                  
<#}#>
</tr>


 <#
       
              var dataLength=DocData.length;
              window.status="Total Records Found :"+ dataLength;
              var objRow;   
        for(var j=0;j<dataLength;j++)
        {

        objRow = DocData[j];
        
            #>
<tr >
<td id="tdSno" class="GridViewLabItemStyle" ><#=j+1#></td>
<#
        for(var k in objRow)
        {
        if(k=='DocGroup' || k=='RoomType' )
        {
                  #>
                  <td class="GridViewLabItemStyle" style="width:150px;"><#=objRow[k]#><input id="txt" type="text" value="<#=objRow[k]#>" style="width:150px; display:none;"/></td>
                  <#}else if(k=='SubCategoryID'){#>
                    <td class="GridViewLabItemStyle" style="width:150px; display:none;"><input id="txt" type="text" value="<#=objRow[k]#>" style="width:150px;"/></td>
                   <#}else{#>
<td class="GridViewLabItemStyle" >
<input id="txt" type="text" value="<#=objRow[k]#>"  style="width:75px" class="ItDoseTextinputNum"/></td>
                      
<#}}}#>

</tr>
     </table>    
        </script>
         <div class="POuter_Box_Inventory">
         <div style="text-align: center">
                            <input id="btnSave" type="button" value="Save" class="ItDoseButton" onclick="SaveData()" />
             <asp:CheckBox ID="chkAll" runat="server" Text="Apply To All" />
                        </div>
             </div>
    </div>
</asp:Content>
